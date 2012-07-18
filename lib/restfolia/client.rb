module Restfolia
  class Client

    def initialize(builder)
      @builder = builder
    end

    # Public: Start point for accessing Resources.
    #
    # url - String with the address of service to be accessed.
    #
    # Examples
    #
    #   entry_point = Restfolia.at("http://localhost:9292/recursos/busca")
    #   entry_point.get # => #<Resource ...>
    #
    # Returns Restfolia::EntryPoint object.
    def at(url)
      EntryPoint.new(self, url)
    end

    # Public: Allow to configure client using DSL from builder.
    #
    # block - (optional) DSL builder. See example for details.
    #
    # Examples:
    #
    #   Restfolia.default_client.configure do
    #     behaviours do
    #       on([201]) do |http_response, media_type, client|
    #         if (location = http_response["location"])
    #           client.http_request(:get, location, {})
    #         else
    #           nil
    #         end
    #       end
    #     end
    #   end
    #
    # Returns Restfolia::Builder::ClientBuilder instance.
    def configure(&block)
      @builder.instance_eval(&block) if block_given?
      @builder
    end

    # Public: Client core. All requests pass in this flow:
    # * Check request query and body.
    # * Do HTTP request.
    # * Look for Media Type, using Content-Type.
    # * Look for and execute based on HTTP response.
    #
    # method - :get, :post, :put, :delete
    # url - address. Ex: http://fake.com/srv ou http://user@pass@fake.com/srv
    # request_options - bag of options (default: {}):
    #                   :query - String or Hash. Ex: "test=1" or {:test => "1"}
    #                   :body - Object that respond to body or String to be
    #                   encoded by default MediaType.
    #                   :headers - Hash with header name and value.
    #                   :cookies - String already "encoded" in cookie format.
    #
    # Returns result of defined behaviours, usually a Restfolia::Resource
    #
    # Raises Restfolia::ResponseError for any problem related by response.
    # Raises Restfolia::MediaTypes::DecodeError problem with decoding.
    def http_request(method, url, request_options = {})
      request_options_query(request_options)
      request_options_body(request_options)

      http_resp = @builder.http_client.request(method, url, request_options)

      content_type = (http_resp["content-type"].split(";").first.strip)
      unless (media_type = @builder.media_types.find(content_type))
        msg = "Media Type not found for '#{content_type}'"
        raise Restfolia::ResponseError.new(msg, caller, http_resp)
      end

      if (behaviour = @builder.behaviours.find(http_resp.code.to_i))
        behaviour.call(http_resp, media_type, self)
      else
        unknown_behaviour = @builder.behaviours.unknown_behaviour
        unknown_behaviour.call(http_resp, media_type, self) if unknown_behaviour.respond_to?(:call)
      end
    end

    protected

    def request_options_query(request_options)
      query = request_options[:query]
      query = if query && query.is_a?(String)
                query
              elsif query && query.is_a?(Hash)
                query.map { |k, v| "#{k}=#{URI.encode(v)}" }.join
              end
      request_options[:query] = query
    end

    def request_options_body(request_options)
      body = request_options[:body]
      if body.respond_to?(:body)
        body = body.body
      else
        media_type = @builder.media_types.default_media_type
        body = media_type.encode(body)
      end
      request_options[:body] = body

      request_options
    end

  end
end
