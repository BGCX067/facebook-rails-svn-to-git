module Facebook
  module Users
    DEFAULT_FIELDS = ['uid', 'about_me', 'activities', 'affiliations', 'birthday', 'books'] +
                     ['current_location', 'education_history', 'first_name', 'has_added_app'] +
                     ['hometown_location', 'hs_info', 'interests', 'is_app_user', 'last_name'] +
                     ['meeting_for', 'meeting_sex', 'movies', 'music', 'name', 'notes_count'] +
                     ['pic', 'pic_big', 'pic_small', 'pic_square', 'political', 'profile_update_time'] +
                     ['quotes', 'relationship_status', 'religion', 'sex', 'significant_other_id'] +
                     ['status', 'timezone', 'tv', 'wall_count', 'work_history']

    class << self
      def get_info(uids, fields = nil)
        if !uids.is_a?(Array)
          self.get_info([uids], fields).first
        else
          fields ||= DEFAULT_FIELDS

          options = {:uids => uids, :fields => fields}

          str    = Facebook.fbsession.users_getInfo(options).to_s
          result = XML::Mapping.load_object_from_xml(REXML::Document.new(str).root)
          return result.users
        end
      end

      def get_field(uids, field)
        if !uids.is_a?(Array)
          self.get_field([uids], field).first
        else
          self.get_info(uids, [field]).map{|u| u.send(field.to_sym)}
        end
      end
    end

    class GetInfoResponse
      include XML::Mapping

      root_element_name 'users_getinfo_response'
      array_node :users, 'user', :class => Facebook::User
    end
  end
end
