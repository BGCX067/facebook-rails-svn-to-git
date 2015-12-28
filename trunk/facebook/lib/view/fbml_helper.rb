module Facebook
  # Helpers to generate FBML tags
  module FBMLHelper
    SHARE_META_OPTIONS = %w(medium title video_type video_height video_width description).map(&:intern)
    SHARE_LINK_OPTIONS = %w(image_src video_src target_url).map(&:intern)
    # Renders an <fb:share-button> with the given options
    def share_button(options={})
      %(
      <fb:share-button class="meta">
        #{SHARE_META_OPTIONS.select {|o| options.keys.include?(o) }.collect {|o| %(<meta name="#{o}" content="#{options[o]}" />)}.join("\n") }
        #{SHARE_LINK_OPTIONS.select {|o| options.keys.include?(o) }.collect {|o| %(<link rel="#{o}" href="#{options[o]}" />)}.join("\n")}
      </fb:share-button>
      )
    end
  end
end
