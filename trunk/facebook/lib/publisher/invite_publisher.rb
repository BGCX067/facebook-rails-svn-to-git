module Facebook
  class InvitePublisher
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
      @body = {}
      send(method_name, *params)
      @view          = ActionView::Base.new(self.class.template_path, @body, self)
      @template_name = "#{method_name.to_s}.rhtml"
    end

    def render!
      @content = @view.render :file => @template_name
    end

    def deliver!
      render!
      opts = {:to_ids   => @to_ids,
              :type     => @type,
              :content  => @content,
              :invite   => @invite,
              :image    => @image,
              :next_url => @next_url}
      Facebook::Notifications.send_request(opts)
    end
  end
end
