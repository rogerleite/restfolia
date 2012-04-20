module Restfolia

  # Public: Exception to represent an invalid HTTP response.
  class ResponseError < StandardError; end

  # Public: Separated methods to handle HTTP response by status code.
  module HTTPBehaviour

    # Public: Based on first number of status code, call it's "helper"
    # method. 2xx, 3xx, 4xx and 5xx are the status handled.
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns Restfolia::Resource or raise Librarian::ResponseError if
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
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns Restfolia::Resource if HTTP Response body is not empty.
    # Raises Restfolia::ResponseError if Content-Type header is not
    # "aplication/json".
    def on_2xx(http_response)

      content_type = (http_response["content-type"] == "application/json")
      if !content_type
        msg_error = "Response \"content-type\" header should be \"application/json\""
        raise(ResponseError, msg_error, caller)
      end

      http_body = http_response.body.to_s
      unless http_body.empty?
        json_parsed = parse_body(http_response.body)
        return Resource.new(json_parsed)
      end

      if (location = http_response["location"])
        http_resp = do_request(:get, location)
        return response_by_status_code(http_resp)
      end
      nil
    end

    # Internal: Handles HTTP Response from status range of 3xx.
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns nothing.
    # Raises Restfolia::ResponseError saying not supported.
    def on_3xx(http_response)
      msg_error = "HTTP status 3xx not supported yet. :X"
      raise(ResponseError, msg_error, caller)
    end

    # Internal: Handles HTTP Response from status range of 4xx.
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns nothing.
    # Raises Restfolia::ResponseError Resource not found.
    def on_4xx(http_response)
      raise(ResponseError, "Resource not found.", caller)
    end

    # Internal: Handles HTTP Response from status range of 5xx.
    #
    # http_response - Net::HTTPResponse instance.
    #
    # Returns nothing.
    # Raises Restfolia::ResponseError Internal Server Error.
    def on_5xx(http_response)
      raise(ResponseError, "Internal Server Error.", caller)
    end

    protected

    # Internal: Parse response body, checking for errors.
    #
    # body - String from response. Expected to be a JSON.
    #
    # Returns Hash who represents JSON parsed.
    # Raises Restfolia::ResponseError if body seens invalid somehow.
    def parse_body(body)
      begin
        MultiJson.load(body, :symbolize_keys => true)
      rescue MultiJson::DecodeError => ex
        msg = "Body should be a valid json. #{ex.message}"
        raise ResponseError, msg, caller
      end
    end

    # Internal: Do a HTTP Request.
    #
    # method - :get or :post. For different value, :get is used.
    # url    - a String to request. (ex: http://fake.com/service)
    # args   - Hash options to build request (default: {}):
    #        :query - String to be set with url (optional).
    #        :body  - String to be set with request (optional).
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
      if method == :post
        verb = Net::HTTP::Post.new(uri.request_uri)
      else
        verb = Net::HTTP::Get.new(uri.request_uri)
      end
      verb.body = body if body

      http_resp = http.request(verb)
    end

  end

end
