
# Run this sample from root project:
# $ ruby -rubygems samples/headers_options.rb

$LOAD_PATH << "lib"
require "restfolia"

# Running https://github.com/rogerleite/simple_api
SERVICE_URL = "http://localhost:9292/recursos/busca"

# accessing headers attribute
entry_point = Restfolia.at(SERVICE_URL)
entry_point.headers["ContentyType"] = "application/json"
resource = entry_point.get

# adding in a fancy way
resource = Restfolia.at(SERVICE_URL).
            with_headers("Content-Type" => "application/json",
                         "Accept" => "application/json").
            get

# helper that sets Content-Type and Accept headers
resource = Restfolia.at(SERVICE_URL).
            as("application/json").
            get

puts "Done!"
