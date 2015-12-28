module Facebook
  module Notifications
    class << self
      def send(to_ids, notification, email = nil)
        options = {:to_ids => to_ids, :notification => notification}

        if email
          options.merge!(:email => email)

          xml = Facebook.fbsession.notifications_send(options)

          # Emails require a confirmation url
          url = xml.at('notifications_send_response').inner_html
          if url =~ /^http:\/\//
            return CGI.unescapeHTML(url)
          else
            return false
          end
        else
          Facebook.fbsession.notifications_send(options)
          return true
        end
      end

      def send_request(options)
        next_url = options.delete(:next_url)

        xml = Facebook.fbsession.notifications_sendRequest(options)

        url = xml.at('notifications_sendrequest_response').inner_html
        if url =~ /^http:\/\//
          # We append the next url to redirect to
          result = CGI.unescapeHTML(url) + "&next=#{next_url}&canvas=1"
        else
          result = false
        end

        Facebook.logger.debug("Facebook::Notifications.send_request(#{options.inspect}): #{xml.inspect}")
        return result
      end
    end
  end
end
