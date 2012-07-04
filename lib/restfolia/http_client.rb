module Restfolia

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
