module Facebook
  module Acts
    module FbGroup

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_fb_group
          include Facebook::Acts::FbGroup::InstanceMethods
          extend Facebook::Acts::FbGroup::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
      end
      
      # This module contains instance methods
      module InstanceMethods
        # GID is not included because it should be a column in the db
        ALL_FIELDS = ['nid', 'name', 'description', 'group_type', 'group_subtype'] +
                     ['pic_big', 'pic_small', 'pic_square', 'creator', 'update_time'] +
                     ['recent_news', 'website', 'office', 'venue']

        ALL_FIELDS.each do |field|
          src = <<-end_src
            def #{field}
              Facebook::Groups.get_field(self.gid, '#{field}')
            end
          end_src
          # TODO: don't eval if method already exists
          class_eval src, __FILE__, __LINE__
        end

        # Members
        ['members', 'admins', 'officers', 'not_replied'].each do |membership|
          src = <<-end_src
            def #{membership}
              Facebook::Groups.get_members(self.gid, '#{membership}')
            end
          end_src
          # TODO: don't eval if method already exists
          class_eval src, __FILE__, __LINE__
        end
      end
    end
  end
end
