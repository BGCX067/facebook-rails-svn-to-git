module Facebook
  # Helpers to generate the HTML equivalent of the FBML tags. Useful if you don't find FBML flexible enough and want to send straight HTML.
  module HTMLHelper
    # Renders the same HTML that a <fb:create-button> would create. Useful if creating your own <fb:dashbaord> from scratch.
    def html_create_button(label, url)
      %(
      <div class="dh_new_media_shell">
        <a href="#{url}" class="dh_new_media">
          <div class="tr"><div class="bl"><div class="br"><span>#{label}</span></div></div></div>
        </a>
      </div>
      )
    end 
  end
end
