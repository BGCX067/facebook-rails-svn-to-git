module Facebook
  module EditorHelper
    # Same as +form_for+ but yields an EditorFormBuilder and outputs fb:editor tags instead of form tags
    def editor_form_for(object_name, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:action] ||= options[:url] && url_for(options.delete(:url)) || ""
      concat(tag("fb:editor", options, true), proc.binding)
      editor_fields_for(object_name, *(args << options), &proc)
      concat('</fb:editor>', proc.binding)
    end
    # Same as +fields_for+ but yields an EditorFormBuilder
    def editor_fields_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:builder] = EditorFormBuilder
      fields_for(object_name, *(args << options), &proc)    
    end
    
    class EditorFormBuilder < ActionView::Helpers::FormBuilder
      attr_accessor :object_name, :object

      def initialize(object_name, object, template, options, proc)
        @object_name, @object, @template, @options, @proc = object_name, object, template, options, proc        
      end

      # Divider
      def divider(options = {})
        @template.tag("fb:divider", options)
      end

      # Textarea
      def textarea(field, options = {})
        options = options.dup
        options.merge!(:name => "#{object_name}[#{field}]")
        content = object ? object.send(field) : ""
        @template.content_tag("fb:editor-textarea", content, options)
      end

      # Submit tags
      %w(button cancel).each do |tag|
        src = <<-end_src
          def #{tag}(value, options = {})
            @template.tag("fb:editor-#{tag}", options.merge(:value => value))
          end
        end_src
        class_eval src, __FILE__, __LINE__
      end

      # Input tags
      %w(text time month date).each do |tag|
        src = <<-end_src
          def #{tag}(field, options = {})
            options = options.dup
            options.merge!(:name  => "#\{object_name\}[#\{field\}]")
            options.merge!(:value => "#\{object.send(field)\}") if object
            @template.tag("fb:editor-#{tag}", options)
          end
        end_src
        class_eval src, __FILE__, __LINE__
      end

      # Container tags
      %w(buttonset custom).each do |tag|
        src = <<-end_src
          def #{tag}(options = {}, &block)
            @template.concat(@template.content_tag("fb:editor-#{tag}", @template.capture(&block), options), block.binding)
          end
        end_src
        class_eval src, __FILE__, __LINE__
      end
    end
  end
end