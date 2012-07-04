module Restfolia
  class Client

    def initialize(builder)
      @builder
    end

    def http_request(method, url, request_options)
      # TODO: all the magic go here
      #
      # How to handle query and body params? Can i ask for help at MediaTypes?
      # execute hooks before_request
      # Http Request
      # execute hooks after_request
      # Check Content-Type from response
      # Execute behaviours based on response
    end

  end
end
