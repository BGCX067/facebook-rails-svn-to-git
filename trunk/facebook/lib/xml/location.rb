module Facebook
  class Location
    include XML::Mapping

    text_node :city,    'city',    :optional => true
    text_node :state,   'state',   :optional => true
    text_node :country, 'country', :optional => true
    text_node :zip,     'zip',     :optional => true
  end
end
