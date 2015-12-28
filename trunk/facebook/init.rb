# Add vendor libs to load path
$:.unshift File.join(File.dirname(__FILE__), 'vendor', 'xml-mapping-0.8.1', 'lib')

require 'facebook'

ActionView::Base.send   :include, Facebook::EditorHelper
ActionView::Base.send   :include, Facebook::HTMLHelper
ActionView::Base.send   :include, Facebook::FBMLHelper
ActiveRecord::Base.send :include, Facebook::Acts::FbUser
ActiveRecord::Base.send :include, Facebook::Acts::FbGroup
