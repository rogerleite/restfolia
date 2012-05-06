module Restfolia

  # Public: Store and execute behaviours defined by user. Behaviour is action
  # for one or more HTTP code. See "default behaviours" below.
  #
  # Examples
  #
  #   default behaviours
  #   behaviours do
  #
  #     # 2xx
  #     on(200...300) do |http_response|
  #       content_type = (http_response["content-type"] =~ /application\/json/)
  #       if !content_type
  #         msg_error = "Response \"content-type\" header should be \"application/json\""
  #         raise Restfolia::ResponseError.new(msg_error, caller, http_response)
  #       end
  #
  #       http_body = http_response.body.to_s
  #       if !http_body.empty?
  #         json_parsed = helpers.parse_json(http_response)
  #         Restfolia.create_resource(json_parsed)
  #       elsif (location = http_response["location"])
  #         http_resp = Request.do_request(:get, location)
  #         Restfolia::HTTP.response_by_status_code(http_resp)
  #       else
  #         nil
  #       end
  #     end
  #
  #     # 3xx
  #     on(300...400) do |http_response|
  #       if (location = http_response["location"])
  #         http_resp = Request.do_request(:get, location)
  #         Restfolia::HTTP.response_by_status_code(http_resp)
  #       else
  #         msg_error = "HTTP status #{http_response.code} not supported"
  #         raise Restfolia::ResponseError.new(msg_error, caller, http_response)
  #       end
  #     end
  #
  #     # 4xx
  #     on(400...500) do |http_response|
  #       raise Restfolia::ResponseError.new("Resource not found.",
  #                                          caller, http_response)
  #     end
  #
  #     # 5xx
  #     on(500...600) do |http_response|
  #       raise Restfolia::ResponseError.new("Internal Server Error",
  #                                          caller, http_response)
  #     end
  #
  #   end
  #
  module HTTP
    autoload :Behaviour,     "restfolia/http/behaviour"
    autoload :Configuration, "restfolia/http/configuration"
    autoload :Request,       "restfolia/http/request"

    # Public: Execute behaviour from HTTP Response code.
    #
    # http_response - Net::HTTPResponse with code attribute.
    #
    # Returns value from  "block behaviour".
    def self.response_by_status_code(http_response)
      Behaviour.store.execute(http_response)
    end

    # Public: It's a nice way to define configurations for
    # your behaves using a block.
    #
    # block - Required block to customize your behaves. Below are
    # the methods available inside block:
    #         #on - See #on
    #
    # Examples
    #
    #   Restfolia::HTTP.behaviours do
    #     on(200) { '200 behaviour' }
    #     on([201, 204]) { 'behaviour for 201 and 204 codes' }
    #     on(300...400) { '3xx range' }
    #   end
    #
    # Returns nothing.
    def self.behaviours(&block)
      Behaviour.store.behaviours(&block)
    end

    #default behaviours
    behaviours do

      # 2xx
      on(200...300) do |http_response|
        content_type = (http_response["content-type"] =~ /application\/json/)
        if !content_type
          msg_error = "Response \"content-type\" header should be \"application/json\""
          raise Restfolia::ResponseError.new(msg_error, caller, http_response)
        end

        http_body = http_response.body.to_s
        if !http_body.empty?
          json_parsed = helpers.parse_json(http_response)
          Restfolia.create_resource(json_parsed)
        elsif (location = http_response["location"])
          http_resp = Request.do_request(:get, location)
          Restfolia::HTTP.response_by_status_code(http_resp)
        else
          nil
        end
      end

      # 3xx
      on(300...400) do |http_response|
        if (location = http_response["location"])
          http_resp = Request.do_request(:get, location)
          Restfolia::HTTP.response_by_status_code(http_resp)
        else
          msg_error = "HTTP status #{http_response.code} not supported"
          raise Restfolia::ResponseError.new(msg_error, caller, http_response)
        end
      end

      # 4xx
      on(400...500) do |http_response|
        raise Restfolia::ResponseError.new("Resource not found.",
                                           caller, http_response)
      end

      # 5xx
      on(500...600) do |http_response|
        raise Restfolia::ResponseError.new("Internal Server Error",
                                           caller, http_response)
      end

    end
  end

end
