module Facebook
  module Groups
    class << self
      def get(options = {})
        str    = Facebook.fbsession.groups_get(options).to_s
        result = XML::Mapping.load_object_from_xml(REXML::Document.new(str).root)
        return result.groups
      end

      def get_info(gids, uid = nil)
        if !gids.is_a?(Array)
          self.get_info([gids]).first
        else
          options = {:gids => gids}
          options.merge!(:uid => uid) if uid

          return self.get(options)
        end
      end

      def get_field(gids, field_name, uid = nil)
        if !gids.is_a?(Array)
          self.get_field([gids], field_name, uid).first
        else
          self.get_info(gids, uid).map{|group| group.send(field_name.to_sym)}
        end
      end

      def get_groups(uid)
        self.get(:uid => uid)
      end

      def get_members(gid, list_name = nil)
        options = {:gid => gid}

        str    = Facebook.fbsession.groups_getMembers(options).to_s
        result = XML::Mapping.load_object_from_xml(REXML::Document.new(str).root)

        if list_name
          return result.send(list_name.to_sym)
        else
          return result
        end
      end
    end

    class GetResponse
      include XML::Mapping

      root_element_name 'groups_get_response'
      array_node :groups, 'group', :class => Facebook::Group
    end

    class GetMembersResponse
      include XML::Mapping

      root_element_name 'groups_getmembers_response'
      array_node :members,     'members',     'uid', :class => Integer
      array_node :admins,      'admins',      'uid', :class => Integer
      array_node :officers,    'officers',    'uid', :class => Integer
      array_node :not_replied, 'not_replied', 'uid', :class => Integer
    end
  end
end
