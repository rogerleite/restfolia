
# Run this sample from root project:
# $ ruby samples/changing_behaviour.rb

require "rubygems"
$LOAD_PATH << "lib"
require "restfolia"

begin
  # Default behaviour to redirect 3xx is raise Error
  Restfolia.at("http://google.com.br").get
rescue Restfolia::ResponseError => ex
  puts ex.message
end

module Restfolia::HTTP::Behaviour

  # We can change behaviour of many HTTP status
  # on_2xx(http_response)
  # on_3xx(http_response)
  # on_4xx(http_response)
  # on_5xx(http_response)

  # Here we change 3xx behaviour to return a Resource
  def on_3xx(http_response)
    Restfolia.create_resource(:redirected => "I'm free! :D")
  end

end

resource = Restfolia.at("http://google.com.br").get
puts resource.redirected
