module Restfolia

  # Public: Exception to represent an invalid HTTP response.
  #
  # Examples
  #
  #   begin
  #     # assuming http_response is 404 response
  #     raise ResponseError.new("message", caller, http_response)
  #   rescue Restfolia::ResponseError => ex
  #     ex.http_code # => 404
  #     ex.http_message # => "Not Found"
  #     ex.http_object # => http_response object
  #   end
  #
  class ResponseError < StandardError

    # Returns nil or #code from http_response instance
    attr_reader :http_code

    # Returns nil or status code definition from #http_code
    attr_reader :http_message

    # List of HTTP Status code definitions.
    # Source http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    HTTP_CODE_MSG = {
      # 2xx
      200 => 'OK',
      201 => 'Created',
      202 => 'Accepted',
      203 => 'Non-Authoritative Information',
      204 => 'No Content',
      205 => 'Reset Content',
      206 => 'Partial Content',
      # 3xx
      300 => 'Multiple Choices',
      301 => 'MovedPermanently',
      302 => 'Found',
      303 => 'SeeOther',
      304 => 'NotModified',
      305 => 'UseProxy',
      306 => '(Unused)',
      307 => 'TemporaryRedirect',
      # 4xx
      400 => 'Bad Request',
      401 => 'Unauthorized',
      402 => 'Payment Required',
      403 => 'Forbidden',
      404 => 'Not Found',
      405 => 'Method Not Allowed',
      406 => 'Not Acceptable',
      407 => 'Proxy Authentication Required',
      408 => 'Request Timeout',
      409 => 'Conflict',
      410 => 'Gone',
      411 => 'Length Required',
      412 => 'Precondition Failed',
      413 => 'Request Entity Too Large',
      414 => 'Request-URI Too Long',
      415 => 'Unsupported Media Type',
      416 => 'Requested Range Not Satisfiable',
      417 => 'Expectation Failed',
      # 5xx
      500  => 'Internal Server Error',
      501  => 'Not Implemented',
      502  => 'Bad Gateway',
      503  => 'Service Unavailable',
      504  => 'Gateway Timeout',
      505  => 'HTTP Version Not Supported'
    }

    # Public: Creates a ResponseError.
    #
    # message - String to describe the error.
    # backtrace - Array, usually mounted by Kernel#caller.
    # http_response - Net::HTTPResponse with error.
    #
    # Examples
    #
    #   begin
    #     # assuming http_response is 404 response
    #     raise ResponseError.new("message", caller, http_response)
    #   rescue Restfolia::ResponseError => ex
    #     ex.http_code # => 404
    #     ex.http_message # => "Not Found"
    #     ex.http_object # => http_response object
    #   end
    #
    def initialize(message, backtrace, http_response)
      super(message)
      self.set_backtrace(backtrace)

      @http_response = http_response
      @http_code, @http_message = nil
      if http_response.respond_to?(:code)
        @http_code = http_response.code.to_i
        @http_message = HTTP_CODE_MSG[@http_code] \
                        || "Unknown HTTP code (#{@http_code})"
      end
    end

    # Returns nil or Net::HTTPResponse instance.
    def http_object
      @http_response
    end

  end

end
