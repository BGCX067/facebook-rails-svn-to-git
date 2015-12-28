module Facebook
  class EducationInfo
    include XML::Mapping

    numeric_node :year, 'year', :optional => true
    text_node    :name, 'name'
  end
end
