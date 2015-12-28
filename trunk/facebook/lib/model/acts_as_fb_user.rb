module Facebook
  module Acts
    module FbUser

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_fb_user
          include Facebook::Acts::FbUser::InstanceMethods
          extend Facebook::Acts::FbUser::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
      end
      
      # This module contains instance methods
      module InstanceMethods
        # UID is not included because it should be a column in the db
        ALL_FIELDS = ['about_me', 'activities', 'affiliations', 'birthday', 'books'] +
                     ['current_location', 'education_history', 'first_name', 'has_added_app'] +
                     ['hometown_location', 'hs_info', 'interests', 'is_app_user', 'last_name'] +
                     ['meeting_for', 'meeting_sex', 'movies', 'music', 'name', 'notes_count'] +
                     ['pic', 'pic_big', 'pic_small', 'pic_square', 'political', 'profile_update_time'] +
                     ['quotes', 'relationship_status', 'religion', 'sex', 'significant_other_id'] +
                     ['status', 'timezone', 'tv', 'wall_count', 'work_history']

        ALL_FIELDS.each do |field|
          src = <<-end_src
            def #{field}
              login do
                Facebook::Users.get_field(self.uid, '#{field}')
              end
            end
          end_src
          # TODO: don't eval if method already exists
          class_eval src, __FILE__, __LINE__
        end

        # Friends
        def friends
          login do
            Facebook::Friends.get
          end
        end

        def friends_with_app
          login do
            Facebook::Friends.get_app_users
          end
        end

        # Profile
        def get_fbml
          login do
            Facebook::Profile.get_fbml
          end
        end

        def set_fbml(markup)
          login do
            Facebook::Profile.set_fbml(markup)
          end
        end

        # Groups
        def groups
          login do
            Facebook::Groups.get
          end
        end

        # Pivoting
        def login(&block)
          Facebook.with_user(self) do
            block.call
          end
        end
      end
    end
  end
end
