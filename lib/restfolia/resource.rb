module Restfolia

  # Public: Resource is the representation of JSON response. It transforms
  # all JSON attributes in attributes and provides a "links" method, to
  # help with hypermedia navigation.
  #
  # Examples
  #
  #   resource = Resource.new(:attr_test => "test")
  #   resource.attr_test  # => "test"
  #   resource.links  # => []
  #
  #   resource = Resource.new(:attr_test => "test",
  #                           :links => {:href => "http://service.com",
  #                                      :rel => "self",
  #                                      :type => "application/json"})
  #   resource.attr_test  # => "test"
  #   resource.links  # => [#<Restfolia::EntryPoint ...>]
  #
  # By default, "links" method, expects from JSON to be the following formats:
  #
  #   # Array de Links
  #   "links" : [{ "href" : "http://fakeurl.com/some/service",
  #               "rel" : "self",
  #               "type" : "application/json"
  #             }]
  #
  #   # OR 'single' Links
  #   "links" : { "href" : "http://fakeurl.com/some/service",
  #               "rel" : "self",
  #               "type" : "application/json"
  #             }
  #
  #   # OR node 'Link', that can be Array or single too
  #   "link" : { "href" : "http://fakeurl.com/some/service",
  #               "rel" : "self",
  #               "type" : "application/json"
  #            }
  #
  class Resource

    # Public: Returns the Hash that represents parsed JSON.
    attr_reader :_json

    # Public: Initialize a Resource.
    #
    # json - Hash that represents parsed JSON.
    #
    # Raises ArgumentError if json parameter is not a Hash object.
    def initialize(json)
      unless json.is_a?(Hash)
        raise(ArgumentError, "json parameter have to be a Hash object", caller)
      end
      @_json = json

      #Add json keys as methods of Resource
      #http://blog.jayfields.com/2008/02/ruby-replace-methodmissing-with-dynamic.html
      @_json.each do |method, value|
        next if self.respond_to?(method) && (method != :id) && (method != "id")

        (class << self; self; end).class_eval do
          define_method(method) do |*args|
            value
          end
        end
      end
    end

    # Public: Read links from Resource. Links are optional.
    # See Resource root doc for details.
    #
    # rel - Optional String parameter. Filter links by rel attribute.
    #
    # Returns Empty Array or Array of EntryPoints, if "rel" is informed
    # it returns nil or an instance of EntryPoint.
    def links(rel = nil)
      @links ||= parse_links(@_json)

      return nil if @links.empty? && !rel.nil?
      return @links if @links.empty? || rel.nil?

      @links.detect { |ep| ep.rel == rel }
    end

    protected

    # Internal: Parse links from hash. Always normalize to return
    # an Array of EntryPoints. Check if link has :href and :rel
    # keys.
    #
    # Returns Array of EntryPoints or Empty Array if :links not exist.
    # Raises RuntimeError if link doesn't have :href and :rel keys.
    def parse_links(json)
      links = json[:links] || json[:link] || json['links'] || json['link']
      return [] if links.nil?

      links = [links] unless links.is_a?(Array)
      links.map do |link|
        if (link[:href].nil? && link['href'].nil?) || (link[:rel].nil? && link['rel'].nil?)
          msg = "Invalid hash link: #{link.inspect}"
          raise(RuntimeError, msg, caller)
        end
        EntryPoint.new(link[:href] || link['href'], link[:rel] || link['rel'])
      end
    end

  end

end
