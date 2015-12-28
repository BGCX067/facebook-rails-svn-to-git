module Facebook
  class User
    include XML::Mapping

    root_element_name 'user'

    numeric_node :uid, 'uid'

    text_node    :about_me,             'about_me',             :optional => true
    text_node    :activities,           'activities',           :optional => true
    text_node    :birthday,             'birthday',             :optional => true
    text_node    :books,                'books',                :optional => true
    text_node    :first_name,           'first_name',           :optional => true
    text_node    :interests,            'interests',            :optional => true
    text_node    :last_name,            'last_name',            :optional => true
    text_node    :movies,               'movies',               :optional => true
    text_node    :music,                'music',                :optional => true
    text_node    :name,                 'name',                 :optional => true
    text_node    :pic_big,              'pic_big',              :optional => true
    text_node    :pic_small,            'pic_small',            :optional => true
    text_node    :pic_square,           'pic_square',           :optional => true
    text_node    :political,            'political',            :optional => true
    text_node    :quotes,               'quotes',               :optional => true
    text_node    :relationship_status,  'relationship_status',  :optional => true
    text_node    :religion,             'religion',             :optional => true
    text_node    :sex,                  'sex',                  :optional => true
    text_node    :tv,                   'tv',                   :optional => true

    numeric_node :notes_count,          'notes_count',          :optional => true
    numeric_node :significant_other_id, 'significant_other_id', :optional => true
    numeric_node :timezone,             'timezone',             :optional => true
    numeric_node :wall_count,           'wall_count',           :optional => true

    boolean_node :has_added_app,        'has_added_app', '1', '0', :optional => true
    boolean_node :is_app_user,          'is_app_user',   '1', '0', :optional => true

    object_node  :current_location,     'current_location',  :class => Facebook::Location, :optional => true
    object_node  :hometown_location,    'hometown_location', :class => Facebook::Location, :optional => true

    array_node   :affiliations,         'affiliations',      'affiliation',    :class => Facebook::Affiliation,   :optional => true
    array_node   :education_history,    'education_history', 'education_info', :class => Facebook::EducationInfo, :optional => true
    array_node   :meeting_for,          'meeting_for',       'seeking',        :class => String,                  :optional => true
    array_node   :meeting_sex,          'meeting_sex',       'sex',            :class => String,                  :optional => true
    #TODO: hs, timestamp, status
  end
end
