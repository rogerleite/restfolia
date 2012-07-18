module Restfolia

  module RequestOptions

    # Public: Sets/Returns cookies values as String.
    attr_accessor :cookies

    # Public: Returns Hash to be used as Headers on request.
    def headers
      @headers ||= {}
    end

    # Public: A fluent way to add Cookies to Request.
    #
    # cookies - String in cookie format.
    #
    # Examples
    #
    #   # setting cookie from Google Translate
    #   cookies = "PREF=ID=07eb...; expires=Sat, 26-Apr-2014 19:19:36 GMT; path=/; domain=.google.com, NID=59...; expires=Fri, 26-Oct-2012 19:19:36 GMT; path=/; domain=.google.com; HttpOnly"
    #   resource = Restfolia.at("http://fake.com").
    #                         set_cookies(cookies).get
    #
    # Returns self, always!
    def set_cookies(cookies)
      self.cookies = cookies
      self
    end

    # Public: A fluent way to add HTTP headers.
    # Headers informed here are merged with headers attribute.
    #
    # new_headers - Hash with headers.
    #
    # Examples
    #
    #   entry_point = Restfolia.at("http://fake.com")
    #   entry_point.with_headers("X-Custom1" => "value",
    #                            "X-Custom2" => "value2").get
    #
    # Returns self, always!
    # Raises ArgumentError unless new_headers is a Hash.
    def with_headers(new_headers)
      unless new_headers.is_a?(Hash)
        raise ArgumentError, "New Headers should Hash object."
      end

      headers.merge!(new_headers)
      self
    end

    # Public: A fluent way to add Content-Type and Accept headers.
    #
    # content_type - String value. Ex: "application/json"
    #
    # Returns self, always!
    def as(content_type)
      headers["Content-Type"] = content_type
      headers["Accept"] = content_type
      self
    end

    # Returns Hash with headers, cookies, auth ... etc.
    def request_options
      {:headers => headers,
       :cookies => cookies}
    end

  end

  # Public: Responsible for delegate http demand to Restfolia client. Also
  # has a fancy interface to common HTTP verbs and "operations", like cookies,
  # headers etc.
  #
  # Examples
  #
  #   # use default client to get an Entry Point
  #   ep = Restfolia.at("http://fakeurl.com/some/service")
  #   # => #<EntryPoint ...>
  #
  #   resource = Restfolia.at("http://fakeurl.com/service/id/1").get
  #   resource.links("contacts")
  #   # => #<EntryPoint ...> to "contacts" from this resource
  class EntryPoint

    include Restfolia::RequestOptions

    # Public: Returns the String url of EntryPoint.
    attr_reader :url

    # Public: Returns String that represents the relation of EntryPoint.
    attr_reader :rel

    # Public: Creates an EntryPoint.
    #
    # client - Instance of Restfolia::Client, responsible to deal with
    # http request.
    # url    - A String address of some API service.
    # rel    - An optional String that represents the relation of EntryPoint.
    def initialize(client, url, rel = nil)
      @client = client
      @url = url
      @rel = rel
    end

    # Public: GET request, use response to select a media type based on
    # Content-Type header and execute the defined behaviour for response code.
    #
    # query_param optional. See Restfolia::HttpHelper.query_param for
    # examples and details.
    #
    # Returns the result of defined behaviour.
    def get(query_param = nil)
      options = self.client_options(:query => query_param)
      @client.http_request(:get, self.url, options)
    end

    # Public: POST request, use response to select a media type based on
    # Content-Type header and execute the defined behaviour for response code.
    #
    # body_param required. See Restfolia::HttpHelper.body_param for
    # examples and details.
    #
    # Returns the result of defined behaviour.
    def post(body_param)
      options = self.client_options(:body => body_param)
      @client.http_request(:post, self.url, options)
    end

    # Public: PUT request, use response to select a media type based on
    # Content-Type header and execute the defined behaviour for response code.
    #
    # body_param required. See Restfolia::HttpHelper.body_param for
    # examples and details.
    #
    # Returns the result of defined behaviour.
    def put(body_param)
      options = self.client_options(:body => body_param)
      @client.http_request(:put, self.url, options)
    end

    # Public: DELETE request, use response to select a media type based on
    # Content-Type header and execute the defined behaviour for response code.
    #
    # Returns the result of defined behaviour.
    def delete
      @client.http_request(:delete, self.url, self.client_options)
    end

    protected

    def client_options(args = {})
      options = self.request_options
      if (query = args.delete(:query))
        args[:query] = HttpHelper.query_param(query)
      end
      if args.key?(:body)
        mt = self.media_type(options[:headers])
        args[:body] = HttpHelper.body_param(mt, args[:body])
      end
      options.merge(args)
    end

    def media_type(headers)
      content_type = headers["Content-Type"]
      @client.find_media_type(content_type)
    end
  end

end
