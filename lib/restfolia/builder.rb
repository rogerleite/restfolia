require "restfolia/builder/behaviour_collection"
require "restfolia/builder/media_type_collection"

module Restfolia::Builder

  class ClientBuilder

    attr_reader :http_client

    def initialize
      @media_types = MediaTypeCollection.new
      @behaviours = BehaviourCollection.new
      @http_client = Restfolia::HttpClient.new
    end

    def media_types(&block)
      @media_types.instance_eval(&block) if block_given?
      @media_types
    end

    def behaviours(&block)
      @behaviours.instance_eval(&block) if block_given?
      @behaviours
    end

  end

end
