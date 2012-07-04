require "restfolia/version"

require "restfolia/builder"
require "restfolia/client"
require "restfolia/http_client"
require "restfolia/entry_point"

module Restfolia

  def self.build_client(&block)
    builder = Restfolia::Builder.new
    builder.instance_eval(&block)
    Restfolia::Client.new(builder)
  end

  def self.default_client
    self.build_client do
      media_types do
        register "application/json", Object.new
        #register "application/json+hal", Object.new
      end
      behaviours do
        on(200..300) do
          "2xx range"
        end
      end
    end
  end

end
