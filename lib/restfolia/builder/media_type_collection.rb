module Restfolia::Builder

  class MediaTypeCollection

    def initialize
      self.clear!
    end

    def clear!
      @default = nil
      @medias = {}
      nil
    end

    # Public: Register which MediaType should be used to attend content type.
    #
    # content_type   - Mime type. Ex: "application/json"
    # media_instance - An object that responds to encode/decode. Ex: Restfolia::MediaTypes::Json
    # options        - Hash options (default: {}):
    #                  :default - Boolean. Indicate a MediaType for default cases.
    #
    # Returns nothing.
    def register(content_type, media_instance, options = {})
      if @medias.empty? || options[:default]
        @default = [content_type, media_instance]
      end
      @medias[content_type] = media_instance
    end

    def find(content_type)
      @medias[content_type]
    end

    # Returns ["content-type", media_instance] from default defined media type.
    def default
      @default
    end

    # Returns media_instance from default defined media type.
    def default_media_type
      @default[1] unless @default.nil?
    end

  end

end
