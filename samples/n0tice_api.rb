# This is a small sample to show how to consume search from http://n0tice.org API.
# Reference: http://n0tice.org/developers/
#
# Run this sample from root project:
# $ ruby -rubygems samples/n0tice_api.rb

$LOAD_PATH << "lib"
require "restfolia"

class Restfolia::Resource

  # Return "self" link, if "apiUrl" exists.
  def parse_links(json)
    self_url = json[:apiUrl]
    return [] if self_url.nil?

    [Restfolia::EntryPoint.new(self_url, "self")]
  end

end

result = Restfolia.at("http://n0ticeapis.com/2/search?type=report&location=Brazil").get

puts result.place.name  # => "Brazil"

first_report = result.results.first
puts first_report.headline  # => "Camp Nectar ..."

# Request report info. Ex: http://n0ticeapis.com/2/report/4220
report = first_report.links("self").get
puts report.webUrl  # => "http://..."
