module Restfolia::HTTP

  # Public: Separated methods to handle HTTP response by status code.
  module Behaviour

    # Public: Based on first number of status code, call it's "helper"
    # method. 2xx, 3xx, 4xx and 5xx are the status handled.
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns Restfolia::Resource or raise Restfolia::ResponseError if
    # any validation or problem.
    # Raises RuntimeError if status code is diferent from 2xx, 3xx,
    # 4xx or 5xx ranges.
    def response_by_status_code(http_response)
      case http_response.code.chars.first
      when '2'
        on_2xx(http_response)
      when '3'
        on_3xx(http_response)
      when '4'
        on_4xx(http_response)
      when '5'
        on_5xx(http_response)
      else
        msg = "I don't know what to do with this HTTP code '#{http_response.code}'"
        raise(RuntimeError, msg, caller)
      end
    end

    # Internal: Handles HTTP Response from status range of 2xx.
    # List of Successful 2xx:
    #   200 OK
    #   201 Created
    #   202 Accepted
    #   203 Non-Authoritative Information
    #   204 No Content
    #   205 Reset Content
    #   206 Partial Content
    # Source http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns Restfolia::Resource if HTTP Response body is not empty.
    # Raises Restfolia::ResponseError for any inconsistency with Response.
    def on_2xx(http_response)

      content_type = (http_response["content-type"] =~ /application\/json/)
      if !content_type
        msg_error = "Response \"content-type\" header should be \"application/json\""
        raise Restfolia::ResponseError.new(msg_error, caller, http_response)
      end

      http_body = http_response.body.to_s
      unless http_body.empty?
        json_parsed = parse_body(http_response)
        return Restfolia::Resource.new(json_parsed)
      end

      if (location = http_response["location"])
        http_resp = do_request(:get, location)
        return response_by_status_code(http_resp)
      end
      nil
    end

    # Internal: Handles HTTP Response from status range of 3xx.
    # List of Redirection 3xx:
    #   300 Multiple Choices
    #   301 Moved Permanently
    #   302 Found
    #   303 See Other
    #   304 Not Modified
    #   305 Use Proxy
    #   306 (Unused)
    #   307 Temporary Redirect
    # Source http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns nothing.
    # Raises Restfolia::ResponseError saying not supported.
    def on_3xx(http_response)
      if (location = http_response["location"])
        http_resp = do_request(:get, location)
        return response_by_status_code(http_resp)
      end

      msg_error = "HTTP status #{http_response.code} not supported"
      raise Restfolia::ResponseError.new(msg_error, caller, http_response)
    end

    # Internal: Handles HTTP Response from status range of 4xx.
    # List of Client Error 4xx:
    #  400 Bad Request
    #  401 Unauthorized
    #  402 Payment Required
    #  403 Forbidden
    #  404 Not Found
    #  405 Method Not Allowed
    #  406 Not Acceptable
    #  407 Proxy Authentication Required
    #  408 Request Timeout
    #  409 Conflict
    #  410 Gone
    #  411 Length Required
    #  412 Precondition Failed
    #  413 Request Entity Too Large
    #  414 Request-URI Too Long
    #  415 Unsupported Media Type
    #  416 Requested Range Not Satisfiable
    #  417 Expectation Failed
    # Source http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns nothing.
    # Raises Restfolia::ResponseError Resource not found.
    def on_4xx(http_response)
      raise Restfolia::ResponseError.new("Resource not found.", caller, http_response)
    end

    # Internal: Handles HTTP Response from status range of 5xx.
    # List of Server Error 5xx
    #   500 Internal Server Error
    #   501 Not Implemented
    #   502 Bad Gateway
    #   503 Service Unavailable
    #   504 Gateway Timeout
    #   505 HTTP Version Not Supported
    # Source http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns nothing.
    # Raises Restfolia::ResponseError Internal Server Error.
    def on_5xx(http_response)
      raise Restfolia::ResponseError.new("Internal Server Error", caller, http_response)
    end

    protected

    # Internal: Parse response body, checking for errors.
    #
    # http_response - HTTP Response with body. Expected to be a JSON.
    #
    # Returns Hash who represents JSON parsed.
    # Raises Restfolia::ResponseError if body seens invalid somehow.
    def parse_body(http_response)
      body = http_response.body
      begin
        MultiJson.load(body, :symbolize_keys => true)
      rescue MultiJson::DecodeError => ex
        msg = "Body should be a valid json. #{ex.message}"
        raise Restfolia::ResponseError.new(msg, caller, http_response)
      end
    end

    # Internal: Do a HTTP Request.
    #
    # method - HTTP verb to be used. Options: :get, :post, :put, :delete
    # url    - a String to request. (ex: http://fake.com/service)
    # args   - Hash options to build request (default: {}):
    #        :query   - String to be set with url (optional).
    #        :body    - String to be set with request (optional).
    #        :headers - Hash with headers to be sent in request (optional).
    #
    # Returns an instance of Net::HTTPResponse.
    #
    # Raises URI::InvalidURIError if url attribute is invalid.
    def do_request(method, url, args = {})
      query = args[:query]
      body = args[:body]

      uri = URI.parse(url)
      uri.query = query if query

      http = Net::HTTP.new(uri.host, uri.port)
      verb = case method
             when :get
               Net::HTTP::Get.new(uri.request_uri)
             when :post
               Net::HTTP::Post.new(uri.request_uri)
             when :put
               Net::HTTP::Put.new(uri.request_uri)
             when :delete
               Net::HTTP::Delete.new(uri.request_uri)
             else
               msg = "Method have to be one of: :get, post, :put, :delete"
               raise ArgumentError, msg
             end
      verb.body = body if body
      if (headers = args[:headers])
        headers.each do |header, value|
          verb[header] = value
        end
      end
      if (cookies = args[:cookies])
        verb["Cookie"] = cookies
      end

      http_resp = http.request(verb)
    end

  end

end
