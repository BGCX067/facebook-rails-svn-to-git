module Facebook
  module Profile
    class << self
      def set_fbml(markup, uid = nil)
        options = {:markup => markup}
        options.merge!({:uid => uid}) if uid

        xml = Facebook.fbsession.profile_setFBML(options)
        return xml.at('profile_setfbml_response').inner_html == "1" ? true : false
      end

      def get_fbml(uid = nil)
        options = uid ? {:uid => uid} : {}

        xml = Facebook.fbsession.profile_getFBML(options)
        return CGI.unescapeHTML(xml.at('profile_getfbml_response').inner_html)
      end
    end
  end
end
