module Facebook
  class Affiliation
    include XML::Mapping

    numeric_node :nid,    'nid'
    text_node    :name,   'name'
    text_node    :type,   'type'
    text_node    :year,   'year',   :optional => true
    text_node    :status, 'status', :optional => true
  end
end
