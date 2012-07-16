module Restfolia::Builder

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

end
