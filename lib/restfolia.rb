require "net/http"
require "uri"

require "restfolia/version"
require "restfolia/media_types"
require "restfolia/builder"
require "restfolia/client"
require "restfolia/http_client"
require "restfolia/entry_point"
require "restfolia/errors"

module Restfolia

  def self.build_client(&block)
    builder = Restfolia::Builder.new
    builder.instance_eval(&block)
    Restfolia::Client.new(builder)
  end

  def self.at(url)
    default_client.at(url)
  end

  def self.default_client
    @@default_client ||= build_default_client
  end

  protected

  def self.build_default_client
    build_client do

      media_types do
        register "application/json", Restfolia::MediaTypes::Json.new
        register "text/html", Restfolia::MediaTypes::Bypass.new
      end

      behaviours do
        # 2xx
        on(200..300) do |http_response, media_type, client|
          http_body = http_response.body.to_s.strip
          if !http_body.empty?
            body_parsed = media_type.decode(http_body)
          elsif (location = http_response["location"])
            client.http_request(:get, location, {})
          else
            nil
          end
        end

        # 3xx
        on(300...400) do |http_response, media_type, client|
          if (location = http_response["location"])
            client.http_request(:get, location, {})
          else
            msg_error = "HTTP status #{http_response.code} not supported"
            raise Restfolia::ResponseError.new(msg_error, caller, http_response)
          end
        end

        # 4xx
        on(400...500) do |http_response, media_type, client|
          raise Restfolia::ResponseError.new("Resource not found.",
                                             caller, http_response)
        end

        # 5xx
        on(500...600) do |http_response, media_type, client|
          raise Restfolia::ResponseError.new("Internal Server Error",
                                             caller, http_response)
        end

        on_unknown do |http_response, media_type, client|
          msg = "Undefined behaviour for #{http_response.code}"
          raise Restfolia::ResponseError.new(msg, caller, http_response)
        end
      end

    end
  end

end
