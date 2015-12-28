module Facebook
  class NotificationPublisher
    def self.method_missing(method_symbol, *params)
      new(method_symbol, *params).deliver!
    end

    def initialize(method_name, *params)
      send(method_name, *params)
    end

    def deliver!
      Facebook::Notifications.send(@to_ids, @text)
    end
  end
end
