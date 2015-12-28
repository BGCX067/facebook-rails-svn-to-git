module Facebook
  class ProfilePublisher
    def self.method_missing(method_symbol, *params)
      new(method_symbol, *params).deliver!
    end

    def self.template_path
      "#{RAILS_ROOT}/app/views/#{Inflector.underscore(self.name)}"
    end

    def logger
      Facebook.logger
    end

    def initialize(method_name, *params)
      send(method_name, *params)
      @view          = ActionView::Base.new(self.class.template_path, self.variables_for_view, self)
      @template_name = "#{method_name.to_s}.rhtml"
    end

    def variables_for_view
      hash = self.instance_values
      hash.delete('view')
      hash.delete('template_name')
      hash
    end

    def render!
      @content = @view.render :file => @template_name
    end

    def deliver!
      render!
      Facebook.with_user(@user) do
        Facebook::Profile.set_fbml(@content)
      end
    end
  end
end
