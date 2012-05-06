
# Run this sample from root project:
# $ ruby samples/http_behaviour.rb

require "rubygems"
$LOAD_PATH << "lib"
require "restfolia"
require "ostruct"

Restfolia::HTTP.behaviours do

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
      http_resp = do_request(:get, location)
      response_by_status_code(http_resp)
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

  #helpers do
  #  def custom_helper
  #    'lixo'
  #  end
  #end

end

SERVICE_URL = "http://localhost:9292/recursos/busca"
resource = Restfolia.at(SERVICE_URL).get
puts resource.inspect

Restfolia.at("http://google.com").get
# => "3xx error"
