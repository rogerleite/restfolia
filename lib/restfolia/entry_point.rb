module Restfolia


  # Public: Responsible for request and validate a Resource.
  # Abstract details of how to deal with HTTP, like headers,
  # cookies, auth etc.
  # The correct form to create an EntryPoint, is using Restfolia.at
  # or links from some instance of Restfolia::Resource. See the
  # examples for more details.
  #
  # Examples
  #
  #   ep = Restfolia.at("http://fakeurl.com/some/service")
  #   # => #<EntryPoint ...>
  #
  #   resource = Restfolia.at("http://fakeurl.com/service/id/1").get
  #   resource.links("contacts")
  #   # => #<EntryPoint ...> to "contacts" from this resource
  class EntryPoint

    include Restfolia::HTTP::Behaviour
    include Restfolia::HTTP::Configuration

    # Public: Returns the String url of EntryPoint.
    attr_reader :url

    # Public: Returns String that represents the relation of EntryPoint.
    attr_reader :rel

    # Public: Creates an EntryPoint.
    #
    # url - A String address of some API service.
    # rel - An optional String that represents the relation of EntryPoint.
    def initialize(url, rel = nil)
      @url = url
      @rel = rel
    end

    # Public: Get the Resource from this EntryPoint's url.
    #
    # params - an optional query String or Hash object. String parameter
    # is passed direct as query. Hash object, before mounting query,
    # URI.encode is used on values.
    #
    # Examples
    #
    #   # GET on http://service.com/search
    #   resource = Restfolia.at("http://service.com/search").get
    #
    #   # GET on http://service.com/search?q=test
    #   resource = Restfolia.at("http://service.com/search").get(:q => "test")
    #   # or if you want to control your query, you can send a String
    #   resource = Restfolia.at("http://service.com/search").get("q=test")
    #
    # Returns depends on http code from response. For each "range"
    # (ex. 2xx, 3xx ... etc) you can have a different return value.
    # For 2xx range, you can expect an instance of Restfolia::Resource.
    # You can see Restfolia::HttpBehaviour for more details.
    #
    # Raises Restfolia::ResponseError for unexpected conditions. See
    # Restfolia::HTTP::Behaviour methods for more details.
    # Raises URI::InvalidURIError if url attribute is invalid.
    def get(params = nil)
      query = if params && params.is_a?(String)
                params
              elsif params && params.is_a?(Hash)
                params.map { |k, v| "#{k}=#{URI.encode(v)}" }.join
              end

      args = self.configuration.merge(:query => query)
      http_resp = do_request(:get, self.url, args)
      response_by_status_code(http_resp)
    end

    # Public: Post data to EntryPoint's url.
    #
    # params - Hash object with data to be encoded as JSON and send as
    # request body.
    #
    # Examples
    #
    #   # Expecting API respond with 201 and Location header
    #   data = {:name => "Test"}
    #   resource = Restfolia.at("http://service.com/resource/1").post(data)
    #
    # Returns depends on http code from response. For each "range"
    # (ex. 2xx, 3xx ... etc) you can have a different return value.
    # For 2xx range, you can expect an instance of Restfolia::Resource.
    # You can see Restfolia::HttpBehaviour for more details.
    #
    # Raises Restfolia::ResponseError for unexpected conditions. See
    # Restfolia::HTTP::Behaviour methods for more details.
    # Raises URI::InvalidURIError if url attribute is invalid.
    def post(params)
      body = MultiJson.dump(params)

      args = self.configuration.merge(:body => body)
      http_resp = do_request(:post, self.url, args)
      response_by_status_code(http_resp)
    end

    # Public: Put data to EntryPoint's url.
    #
    # params - Hash object with data to be encoded as JSON and send as
    # request body.
    #
    # Examples
    #
    #   # Expecting API respond with 201 and Location header
    #   data = {:name => "Test"}
    #   resource = Restfolia.at("http://service.com/resource/1").put(data)
    #
    # Returns depends on http code from response. For each "range"
    # (ex. 2xx, 3xx ... etc) you can have a different return value.
    # For 2xx range, you can expect an instance of Restfolia::Resource.
    # You can see Restfolia::HttpBehaviour for more details.
    #
    # Raises Restfolia::ResponseError for unexpected conditions. See
    # Restfolia::HTTP::Behaviour methods for more details.
    # Raises URI::InvalidURIError if url attribute is invalid.
    def put(params)
      body = MultiJson.dump(params)

      args = self.configuration.merge(:body => body)
      http_resp = do_request(:put, self.url, args)
      response_by_status_code(http_resp)
    end

    # Public: Send Delete verb to EntryPoint's url.
    #
    # Examples
    #
    #   # Expecting API respond with 204 and empty body
    #   resource = Restfolia.at("http://service.com/resource/1").delete
    #
    # Returns depends on http code from response. For each "range"
    # (ex. 2xx, 3xx ... etc) you can have a different return value.
    # For 2xx range, you can expect an instance of Restfolia::Resource.
    # You can see Restfolia::HttpBehaviour for more details.
    #
    # Raises Restfolia::ResponseError for unexpected conditions. See
    # Restfolia::HTTP::Behaviour methods for more details.
    # Raises URI::InvalidURIError if url attribute is invalid.
    def delete
      http_resp = do_request(:delete, self.url, self.configuration)
      response_by_status_code(http_resp)
    end

    # Returns url and rel for inspecting.
    def inspect
      "#<#{self.class} @url=\"#{@url}\" @rel=\"#{@rel}\">"
    end

  end


end
