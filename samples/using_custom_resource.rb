
# Run this sample from root project:
# $ ruby -rubygems samples/using_custom_resource.rb

$LOAD_PATH << "lib"
require "restfolia"
require "ostruct"

# Running https://github.com/rogerleite/simple_api
SERVICE_URL = "http://localhost:9292/recursos/busca"

resource = Restfolia.at(SERVICE_URL).get
#puts resource.inspect # => #<Restfolia::Resource ...>

# Here you have the advantage to use a custom resource
# and the same time you have the recursive lookup at hash
class Restfolia::ResourceCreator
  def resource_class
    OpenStruct
  end
end
resource = Restfolia.at(SERVICE_URL).get
puts resource.inspect # => #<OpenStruct ...>

puts "Done!"
