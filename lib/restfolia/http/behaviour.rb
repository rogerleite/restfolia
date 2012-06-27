module Restfolia::HTTP

  # Public: Separated methods to handle HTTP response by status code.
  module Behaviour

    # Returns Restfolia::HTTP::Behaviour::Store instance.
    def self.store
      @store ||= Store.new
    end

    # Internal: Helpers Available to behaviours blocks
    #
    # Examples
    #
    #   Restfolia::HTTP.behaviours do
    #     on(200) do |http_response|
    #       helpers.parse_json(http_response.body)
    #     end
    #   end
    class Helpers

      # Internal: Parse response body, checking for errors.
      #
      # http_response - HTTP Response with body. Expected to be a JSON.
      #
      # Returns Hash who represents JSON parsed.
      # Raises Restfolia::ResponseError if body seens invalid somehow.
      def parse_json(http_response)
        body = http_response.body
        begin
          MultiJson.decode(body, :symbolize_keys => true)
        rescue MultiJson::DecodeError => ex
          msg = "Body should be a valid json. #{ex.message}"
          raise Restfolia::ResponseError.new(msg, caller, http_response)
        end
      end

      # Public: Request url with GET and forwards to Restfolia::HTTP.
      #
      # url - String. Ex: http://service.com/resources
      #
      # Returns what Restfolia::HTTP.response_by_status_code returns.
      def follow_url(url)
        http_resp = Request.do_request(:get, url)
        Restfolia::HTTP.response_by_status_code(http_resp)
      end

    end

    # Public: Responsible to store behaviours. See #behaviours for details.
    class Store

      # Returns Restfolia::HTTP::Behaviour::Helpers instance.
      attr_reader :helpers

      # Public: Creates a Store.
      def initialize
        self.clear!
        @helpers = Helpers.new
      end

      # Public: clear all defined behaviours.
      # Returns nothing.
      def clear!
        @behaviours = {}
        @behaviours_range = {}
        nil
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
      #   store = Restfolia::HTTP::Behaviour::Store.new
      #   store.behaviours do
      #     on(200) { '200 behaviour' }
      #     on([201, 204]) { 'behaviour for 201 and 204 codes' }
      #     on(300...400) { '3xx range' }
      #   end
      #
      # Returns nothing.
      def behaviours(&block)
        self.instance_eval(&block)
        nil
      end

      # Public: Add behaviour on this store. See #behaviours for
      # examples.
      #
      # code  - Integer or any object that respond to #include?
      # block - Required block with behaviour for this code.
      #
      # Returns nothing.
      def on(code, &block)
        if code.is_a?(Integer)
          @behaviours[code] = block
        elsif code.respond_to?(:include?)
          @behaviours_range[code] = block
        end
        nil
      end

      # Public: Method called by #execute in case of 'not found' http code.
      #
      # http_response - Net::HTTPResponse object.
      #
      # Examples
      #
      #   store = Restfolia::HTTP::Behaviour::Store.new
      #   store.behaviours do
      #     on(200) { '200 ok' }
      #   end
      #   http_resp = OpenStruct.new(:code => 201) #simulate response 201
      #   store.execute(http_resp)
      #   # => #<Restfolia::ResponseError "Undefined behaviour for 201" ...>
      #
      # Returns nothing.
      # Raises Restfolia::ResponseError
      def default_behaviour(http_response)
        msg = "Undefined behaviour for #{http_response.code}"
        raise Restfolia::ResponseError.new(msg, caller, http_response)
      end

      # Public: Look for defined behaviour, based on HTTP code.
      # If behaviour not found, call #default_behaviour.
      #
      # http_response - Net::HTTPResponse.
      # Returns Result from Proc behaviour or default_behaviour method.
      def execute(http_response)
        code = http_response.code.to_i
        if (behaviour = find(code))
          behaviour.call(http_response)
        else
          default_behaviour(http_response)
        end
      end

      protected

      # Internal: Search for defined behaviour.
      #
      # code - Integer or object that respond to #include?
      #
      # Returns nil or Proc
      def find(code)
        behaviour = @behaviours[code]
        if behaviour.nil?
          _, behaviour = @behaviours_range.detect do |range, proc|
            range.include?(code)
          end
        end
        behaviour
      end

    end

  end

end
