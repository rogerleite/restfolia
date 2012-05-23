
# Run this sample from root project:
# $ ruby -rubygems samples/http_behaviour.rb

$LOAD_PATH << "lib"
require "restfolia"

Restfolia::HTTP.behaviours do

  clear!  #clear all defined behaviours

  on(200) do |http_response|
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
      helpers.follow_url(location)
    else
      nil
    end
  end

  # 3xx range
  on(300...400) do
    raise "3xx error"
  end

  #on([404, 402]) do
  #  custom_helper
  #end

end

# Running https://github.com/rogerleite/simple_api
SERVICE_URL = "http://localhost:9292/recursos/busca"

resource = Restfolia.at(SERVICE_URL).get
puts resource.inspect  # => #<Restfolia::Resource ...>

Restfolia.at("http://google.com").get
# => "3xx error"
