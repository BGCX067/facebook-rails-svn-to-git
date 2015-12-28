module Facebook
  class FBMLController < ActionController::Base
    session :off

    around_filter do |controller, block|
      if controller.fbsession.is_valid?
        Facebook.with_fbsession(controller.fbsession) do
          block.call
        end
      else
        logger.debug 'No valid facebook session'
        block.call
      end
    end

    def fbparams
      @fbparams ||= {};

      if (@fbparams.length <= 0)
        @fbparams = fbsession.get_fb_sig_params(params)
      end

      return @fbparams
    end

    def fbfriends
      fbparams['friends'].split(',').map(&:to_i)
    end

    def fbsession
      unless @fbsession
        @fbsession = RFacebook::FacebookWebSession.new(Facebook.api_key, Facebook.secret_key)
        
        session_key = fbparams["session_key"]
        user        = fbparams["user"]
        expires     = fbparams["expires"]

        if session_key && user && expires
          @fbsession.activate_with_previous_session(session_key, user, expires)
        end
      end

      return @fbsession
    end

    def require_facebook_install
      if in_canvas? && !fbsession.is_valid?
        redirect_to fbsession.get_install_url
      end
    end

    def in_canvas?
      return fbparams["in_canvas"] != nil
    end

    def redirect_to(url)
      if in_canvas?
        render :text => "<fb:redirect url=\"#{url}\" />"        
      else
        super url
      end
    end

    def url_for(options = {}, *params)
      if options.is_a?(String)
        return options
      elsif options.delete(:canvas) == false
        return super(options, *params)
      else
        # Get the path that Rails would normally generate
        path = super(options.merge(:only_path => true), *params)

        # Rewrite it if it begins with our callback path (ex /fb)
        if path.starts_with?(Facebook.callback_path)
          # Remove the callback path: "/fb/path/to/x" becomes "path/to/x"
          newpath = path[Facebook.callback_path.length+1..-1]

          # Done if we're not adding the canvas path
          return newpath if options.delete(:only_path_no_prefix)

          # Append the canvas path: "path/to/x" becomes "/myapp/path/to/x"
          newpath = Facebook.canvas_path + '/' + newpath

          # Done if we're only getting the path
          return newpath if options.delete(:only_path)

          # Append the facebook domain: "/myapp/path/to/x" becomes "http://apps.facebook.com/myapp/path/to/x"
          newpath = 'http://apps.facebook.com' + newpath
          return newpath
        else
          raise StandardError, "#{path} does not begin with #{Facebook.callback_path}"
        end
      end
    end
  end
end
