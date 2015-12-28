module Facebook
  module Feed
    class << self
      def publish_action_of_user(title, options = {})
        options = options.merge({:title => title})

        xml = Facebook.fbsession.feed_publishActionOfUser(options)
        return xml.at('feed_publishactionofuser_response').inner_html == "1" ? true : false
      end

      def publish_story_to_user(title, options = {})
        options = options.merge({:title => title})

        xml = Facebook.fbsession.feed_publishStoryToUser(options)
        return xml.at('feed_publishstorytouser_response').inner_html == "1" ? true : false
      end
    end
  end
end
