module Restfolia

  class Builder

    attr_reader :http_client

    def initialize
      @media_types = MediaTypeCollection.new
      @behaviours = BehaviourCollection.new
      @http_client = Restfolia::HttpClient.new
    end

    def media_types(&block)
      @media_types.instance_eval(&block) if block_given?
      @media_types
    end

    def behaviours(&block)
      @behaviours.instance_eval(&block) if block_given?
      @behaviours
    end

  end

  class BehaviourCollection

    attr_reader :unknown_behaviour

    def initialize
      self.clear!
    end

    def clear!
      @behaviours = {}
      @behaviours_range = {}
      @unknown_behaviour = nil
      nil
    end

    def on(code, &block)
      if code.is_a?(Integer)
        @behaviours[code] = block
      elsif code.respond_to?(:include?)
        @behaviours_range[code] = block
      end
      nil
    end

    def on_unknown(&block)
      @unknown_behaviour = block
    end

    def find(code)
      behaviour = @behaviours[code]
      if behaviour.nil?
        _, behaviour = @behaviours_range.detect do |range, proc|
          range.include?(code)
        end
      end
      behaviour
    end

  end

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
