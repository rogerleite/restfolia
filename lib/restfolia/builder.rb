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

    def initialize
      self.clear!
    end

    def clear!
      @behaviours = {}
      @behaviours_range = {}
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
      @medias = {}
      nil
    end

    def register(content_type, media_class)
      @medias[content_type] = media_class
    end

    def find(content_type)
      @medias[content_type]
    end

  end

end
