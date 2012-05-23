
# Run this sample from root project:
# $ ruby -rubygems samples/changing_links_parse.rb

$LOAD_PATH << "lib"
require "restfolia"

resource = Restfolia::Resource.new(:attr_test => "test",
                                   :custom_links => [
                                     {:url => "http://test.com", :rel => "rel"}
                                   ])
puts resource.links.inspect  # => []

# Now let's change the way Resource parses links
class Restfolia::Resource

  def parse_links(json)
    links = json[:custom_links]
    return [] if links.nil?

    links = [links] unless links.is_a?(Array)
    links.map do |link|
      if link[:url].nil? || link[:rel].nil?
        msg = "Invalid hash link: #{link.inspect}"
        raise(RuntimeError, msg, caller)
      end
      Restfolia::EntryPoint.new(link[:url], link[:rel])
    end
  end

end

resource = Restfolia::Resource.new(:attr_test => "test",
                                   :custom_links => [
                                     {:url => "http://test.com", :rel => "rel"}
                                   ])
puts resource.links.inspect  # => [#<Restfolia::EntryPoint ...>]
