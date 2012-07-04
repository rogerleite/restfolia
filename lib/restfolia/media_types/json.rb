require "multi_json"

module Restfolia::MediaTypes
  class Json

    def encode(value)
      MultiJson.encode(value)
    end

    def decode(value)
      begin
        MultiJson.decode(value, :symbolize_keys => true)
      rescue MultiJson::DecodeError => ex
        msg = "Value should be a valid json. #{ex.message}"
        raise Restfolia::MediaTypes::DecodeError.new(msg, caller, value)
      end
    end

  end
end
