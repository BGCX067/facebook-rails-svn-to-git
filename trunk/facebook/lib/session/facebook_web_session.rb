# Copyright (c) 2007, Matt Pizzimenti (www.livelearncode.com)
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
# Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# Neither the name of the original author nor the names of contributors
# may be used to endorse or promote products derived from this software
# without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

#
# Some code was inspired by techniques used in Alpha Chen's old client.
# Some code was ported from the official PHP5 client.
#

module RFacebook

class FacebookWebSession < FacebookSession
  
    # SECTION: Properties
    
    def session_key
      return @session_key
    end
  
    def session_user_id
      return @session_uid
    end
  
    def session_expires
      return @session_expires
    end
    
    # SECTION: URL Getters
    
    # Function: get_login_url
    #   Gets the authentication URL
    #
    # Parameters:
    #   options.next          - the page to redirect to after login
    #   options.popup         - boolean, whether or not to use the popup style (defaults to true)
    #   options.skipcookie    - boolean, whether to force new Facebook login (defaults to false)
    #   options.hidecheckbox  - boolean, whether to show the "infinite session" option checkbox
    def get_login_url(options={})

      # handle options
      nextPage = options[:next] ||= nil
      popup = (options[:popup] == nil) ? false : true
      skipcookie = (options[:skipcookie] == nil) ? false : true
      hidecheckbox = (options[:hidecheckbox] == nil) ? false : true
      frame = (options[:frame] == nil) ? false : true
      canvas = (options[:canvas] == nil) ? false : true
    
      # url pieces
      optionalNext = (nextPage == nil) ? "" : "&next=#{CGI.escape(nextPage.to_s)}"
      optionalPopup = (popup == true) ? "&popup=true" : ""
      optionalSkipCookie = (skipcookie == true) ? "&skipcookie=true" : ""
      optionalHideCheckbox = (hidecheckbox == true) ? "&hide_checkbox=true" : ""
      optionalFrame = (frame == true) ? "&fbframe=true" : ""
      optionalCanvas = (canvas == true) ? "&canvas=true" : ""
    
      # build and return URL
      return "http://#{WWW_SERVER_BASE_URL}#{WWW_PATH_LOGIN}?v=1.0&api_key=#{@api_key}#{optionalPopup}#{optionalNext}#{optionalSkipCookie}#{optionalHideCheckbox}#{optionalFrame}#{optionalCanvas}"
    
    end
    
    def get_install_url(options={})
    
      # handle options
      nextPage = options[:next] ||= nil
    
      # url pieces
      optionalNext = (nextPage == nil) ? "" : "&next=#{CGI.escape(nextPage.to_s)}"
    
      # build and return URL
      return "http://#{WWW_SERVER_BASE_URL}#{WWW_PATH_INSTALL}?api_key=#{@api_key}#{optionalNext}"
    
    end
  

    # SECTION: Callback Verification Helpers
    
    def get_fb_sig_params(originalParams)
            
      # setup
      timeout = 48*3600
      namespace = "fb_sig"
      prefix = "#{namespace}_"
      
      # get the params prefixed by "fb_sig_" (and remove the prefix)
      sigParams = {}
      originalParams.each do |k,v|
        oldLen = k.length
        newK = k.sub(prefix, "")
        if oldLen != newK.length
          sigParams[newK] = v
        end
      end
      
      # handle invalidation
      if (timeout and (sigParams["time"].nil? or (Time.now.to_i - sigParams["time"].to_i > timeout.to_i)))
        # invalidate if the timeout has been reached
        sigParams = {}
      end
      
      if !sig_params_valid?(sigParams, originalParams[namespace])
        # invalidate if the signatures don't match
        sigParams = {}
      end
      
      return sigParams
      
    end
  
  
  
    # SECTION: Session Activation
  
    # Function: activate_with_token
    #   Gets the session information available after current user logs in.
    # 
    # Parameters:
    #   auth_token    - string token passed back by the callback URL
    def activate_with_token(auth_token)
      result = call_method("auth.getSession", {:auth_token => auth_token})
      if result != nil
        @session_uid = result.at("uid").inner_html
        @session_key = result.at("session_key").inner_html
        @session_expires = result.at("expires").inner_html
      end
    end
  
    # Function: activate_with_previous_session
    #   Sets the session key directly (for example, if you have an infinite session key)
    # 
    # Parameters:
    #   key    - the session key to use
    def activate_with_previous_session(key, uid=nil, expires=nil)
      
      # TODO: what is a good way to handle expiration?
      #       low priority since the API will give an error code for me...
      
      # set the session key
      @session_key = key
    
      # determine the current user's id
      if uid
        @session_uid = uid
      else
        result = call_method("users.getLoggedInUser")
        @session_uid = result.at("users_getLoggedInUser_response").inner_html
      end
      
    end
  
    def is_valid?
      return (is_activated? and !session_expired?)
    end
  
  
  
  
  
  
    # SECTION: Protected methods
    protected
  
    def is_activated?
      return (@session_key != nil)
    end
  
    # Function: get_secret
    #   Template method, used by super::signature to generate a signature
    def get_secret(params)
      return @api_secret
    end
    
    def sig_params_valid?(sigParams, expectedSig)
      return (sigParams and expectedSig and generate_signature(sigParams, @api_secret) == expectedSig)
    end
  
  end



end