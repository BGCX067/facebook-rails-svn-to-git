module Facebook
  class FeedPublisher
    def self.method_missing(method_symbol, *params)
      new(method_symbol, *params).deliver!
    end

    def initialize(method_name, *params)
      send(method_name, *params)
    end

    def abort
      @abort = true
    end

    def options_for_publish
      {:body        => @body,
       :image_1     => @image_1,
       :image_1_url => @image_1_url,
       :image_2     => @image_2,
       :image_2_url => @image_2_url,
       :image_3     => @image_3,
       :image_3_url => @image_3_url,
       :image_4     => @image_4,
       :image_4_url => @image_4_url
       }
    end

    def deliver!
      if @abort
        return nil
      else
        @options = options_for_publish
        publish!
      end
    end

    def publish!
      Facebook::Feed.publish_action_of_user(@title, @options)
    end
  end
end
