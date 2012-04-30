
# Run this sample from root project:
# $ ruby samples/using_custom_factory.rb

require "rubygems"
$LOAD_PATH << "lib"
require "restfolia"
require "ostruct"

SERVICE_URL = "http://localhost:9292/recursos/busca"

resource = Restfolia.at(SERVICE_URL).get
puts resource.inspect # => #<Restfolia::Resource ...>

# Here you have the "pure" json from response body.
# You can do anything.
module Restfolia
  def self.create_resource(json)
    OpenStruct.new(json)
  end
end
resource = Restfolia.at(SERVICE_URL).get
puts resource.inspect # => #<OpenStruct ...>

puts "Done!"
