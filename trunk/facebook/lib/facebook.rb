require 'session/facebook_session'
require 'session/facebook_web_session'
require 'xml/mapping'
require 'utils/dynamic'

require 'controllers/fbml_controller'
require 'model/acts_as_fb_group'
require 'model/acts_as_fb_user'
require 'view/editor_helper'
require 'view/html_helper'
require 'view/fbml_helper'
require 'publisher/feed_publisher'
require 'publisher/story_publisher'
require 'publisher/profile_publisher'
require 'publisher/notification_publisher'
#require 'publisher/email_publisher'
require 'publisher/invite_publisher'
require 'xml/affiliation'
require 'xml/location'
require 'xml/education_info'
require 'xml/group'
require 'xml/user'
require 'api/feed'
require 'api/fql'
require 'api/friends'
require 'api/groups'
require 'api/notifications'
require 'api/profile'
require 'api/users'

module Facebook
  LOGGER = Logger.new("#{RAILS_ROOT}/log/facebook.log")

  class << self
    attr_accessor :api_key
    attr_accessor :secret_key
    attr_accessor :canvas_path
    attr_accessor :callback_path

    Dynamic.variable :fbsession => nil

    def with_user(user, &block)
      if user.respond_to?(:uid) && user.respond_to?(:session_key)
        with_previous_session(user.uid, user.session_key) do
          block.call
        end
      else
        raise ArgumentError "Must respond to uid and session_key"
      end
    end

    def with_previous_session(uid, session_key, &block)
      fbsession = RFacebook::FacebookWebSession.new(api_key, secret_key)
      fbsession.activate_with_previous_session(session_key, uid)

      with_fbsession(fbsession) do
        block.call
      end
    end

    def with_fbsession(fbsession, &block)
      Dynamic.let(:fbsession => fbsession) do
        block.call
      end
    end

    def fbsession
      Dynamic.fbsession
    end

    def logger
      LOGGER
    end
  end
end

class String
  def self.load_from_xml(xml, options={:mapping=>:_default})
    xml.text
  end
end

class Integer
  def self.load_from_xml(xml, options={:mapping=>:_default})
    xml.text.to_i
  end
end
