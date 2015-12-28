module Facebook
  module Friends
    class << self
      def get
        str    = Facebook.fbsession.friends_get.to_s
        result = XML::Mapping.load_object_from_xml(REXML::Document.new(str).root)
        return result.uids
      end

      def get_app_users
        str    = Facebook.fbsession.friends_getAppUsers.to_s
        result = XML::Mapping.load_object_from_xml(REXML::Document.new(str).root)
        return result.uids
      end
    end

    class GetResponse
      include XML::Mapping
    
      root_element_name 'friends_get_response'
      array_node :uids, 'uid', :class => Integer
    end

    class GetAppUsersResponse
      include XML::Mapping

      root_element_name 'friends_getappusers_response'
      array_node :uids, 'uid', :class => Integer
    end
  end
end
