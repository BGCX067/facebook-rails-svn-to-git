module Facebook
  class Group
    include XML::Mapping

    root_element_name 'group'

    numeric_node :gid, 'gid'
    numeric_node :nid, 'nid', :optional => true

    text_node :name,          'name',          :optional => true
    text_node :description,   'description',   :optional => true
    text_node :group_type,    'group_type',    :optional => true
    text_node :group_subtype, 'group_subtype', :optional => true

    text_node :pic_big,    'pic_big',    :optional => true
    text_node :pic_small,  'pic_small',  :optional => true
    text_node :pic_square, 'pic_square', :optional => true

    numeric_node :creator,     'creator',     :optional => true
    numeric_node :update_time, 'update_time', :optional => true

    text_node :recent_news, 'recent_news', :optional => true
    text_node :website,     'website',     :optional => true
    text_node :office,      'office',      :optional => true

    object_node :venue, 'venue',  :class => Facebook::Location, :optional => true
  end
end
