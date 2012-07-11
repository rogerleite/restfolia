require "multi_json"

module Restfolia::MediaTypes
  class Json

    def initialize
      @creator = Restfolia::Resources::HashCrawler.new
      @creator.attributes_to_dont_parse = [:links, :link, 'links', 'link']
    end

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

    def create_resource(client, http_response)
      body_parsed = self.decode(http_response.body.to_s)
      @creator.create(body_parsed) do |json_hash|
        Restfolia::Resources::Json.new(client, json_hash)
      end
    end

  end
end
