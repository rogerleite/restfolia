module Restfolia::MediaTypes
  class Bypass

    def encode(value)
      value
    end

    def decode(value)
      value
    end

    def create_resource(client, http_response)
      http_response.body.to_s.strip
    end

  end
end
