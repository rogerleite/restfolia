module Restfolia

  # Internal: Help Restfolia::EntryPoint with HTTP dirty job.
  module HttpHelper

    # Public: Help to apply some rules to query parameter.
    # * query is a String, use string value.
    # * query is a Hash, iterate applying URI.encode in each value,
    # and join with &
    #
    # query - Object
    #
    # Examples
    #   query("var=1&var2=2")  # => "var=1&var2=2"
    #   query(:var1 => 1, :var => 2)  # => "var=1&var2=2"
    #
    # Returns String in http query format.
    def self.query_param(query)
      if query && query.is_a?(String)
        query
      elsif query && query.is_a?(Hash)
        query.map { |k, v| "#{k}=#{URI.encode(v.to_s)}" }.join('&')
      end
    end

    # Public: Help to apply some rules to body parameter.
    #
    # media_type - instance of Media Type object.
    # body - You have some options.
    #        String param is passed direct as body.
    #        Object that responds to :body is passed direct as body.
    #        Hash with data to be encoded by media type parameter.
    #
    # Returns String.
    # Raises ArgumentError for invalid body.
    # Raises ArgumentError for media_type not informed.
    def self.body_param(media_type, body)
      if body && body.is_a?(String)
        body
      elsif body && body.respond_to?(:body)
        body.body
      elsif body && body.kind_of?(Hash)
        if media_type.nil?
          msg = "Check you Content-Type request header. Media Type not found."
          raise ArgumentError, msg
        end
        media_type.encode(body)
      else
        msg = "Invalid body, see Restfolia::HttpHelper.body_param for details."
        msg += "\nBody: #{body.inspect}."
        raise ArgumentError, msg
      end
    end

  end

  # Public: Wraps Net::HTTP interface.
  class HttpClient

    # Public: HTTP Request.
    #
    # method - HTTP verb to be used. Options: :get, :post, :put, :delete
    # url    - String to request. (ex: http://fake.com/service or http://user:password@fake.com/service)
    # args   - Hash options to build request (default: {}):
    #        :query   - String to be set with url (optional).
    #        :body    - String to be set with request (optional).
    #        :headers - Hash with headers to be sent in request (optional).
    #        :cookies - String already "encoded" in cookie format.
    #
    # Returns an instance of Net::HTTPResponse.
    #
    # Raises URI::InvalidURIError if url attribute is invalid.
    def request(method, url, args = {})
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

      verb.basic_auth(uri.user, uri.password) if uri.user
      http.request(verb)
    end

  end

end
