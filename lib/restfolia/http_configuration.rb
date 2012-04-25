module Restfolia

  # Internal: Simply a bag of HTTP options like headers, cookies, auth ... etc.
  module HTTPConfiguration

    # Public: Returns Hash to be used as Headers on request.
    def headers
      @headers ||= {}
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

    protected

    # Internal: A bag of HTTP configurations.
    #
    # Returns Hash with headers, cookies, auth ... etc.
    def configuration
      {:headers => headers}
    end

  end

end
