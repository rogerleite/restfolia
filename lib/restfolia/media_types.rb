module Restfolia

  module MediaTypes

    autoload :Json, "restfolia/media_types/json"
    autoload :Bypass, "restfolia/media_types/bypass"

    class DecodeError < StandardError

      attr_reader :value

      # Public: Creates a DecodeError.
      #
      # message - String to describe the error.
      # backtrace - Array, usually mounted by Kernel#caller.
      # value - Value to be decoded.
      def initialize(message, backtrace, value)
        super(message)
        self.set_backtrace(backtrace)

        @value = value
      end

    end

  end

end
