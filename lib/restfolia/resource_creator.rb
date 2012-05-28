module Restfolia

  # Public: Call a Factory of Resources. This is a good place to override and
  # returns a custom Resource Factory. By default, Restfolia uses
  # Restfolia::ResourceCreator.
  #
  # json - Hash parsed from Response body.
  #
  # Returns Resource instance, configured at ResourceCreator.
  # Raises ArgumentError if json is not a Hash.
  def self.create_resource(json)
    @creator ||= Restfolia::ResourceCreator.new
    @creator.create(json)
  end

  # Public: Factory of Resources. It transforms all JSON objects in Resources.
  #
  # Examples
  #
  #   factory = Restfolia::ResourceCreator.new
  #   resource = factory.create(:attr_test => "test",
  #                             :attr_tags => ["tag1", "tag2"],
  #                             :attr_array_obj => [{:nested => "nested"}],
  #                             :links => [{:href => "http://service.com",
  #                                         :rel => "contacts",
  #                                         :type => "application/json"},
  #                                        {:href => "http://another.com",
  #                                         :rel => "relations",
  #                                         :type => "application/json"}
  #                                       ])
  #   resource.attr_test  # => "test"
  #   resource.attr_tags  # => ["tag1", "tag2"]
  #   resource.attr_array_obj  # => [#<Restfolia::Resource ...>]
  #
  class ResourceCreator

    # Public: creates Resource looking recursively for JSON
    # objects and transforming in Resources. To create Resource,
    # this method use #resource_class.new(json).
    #
    # json - Hash parsed from Response body.
    #
    # Returns Resource from #resource_class.
    # Raises ArgumentError if json is not a Hash.
    def create(json)
      unless json.is_a?(Hash)
        raise(ArgumentError, "JSON parameter have to be a Hash object", caller)
      end

      json_parsed = {}
      json.each do |attr, value|
        json_parsed[attr] = look_for_resource(attr, value)
      end
      resource_class.new(json_parsed)
    end

    protected

    # Internal: By default, returns Restfolia::Resource. You can use
    # this method to override and returns a custom Resource.
    #
    # Examples
    #
    #   # using a custom Resource
    #   class Restfolia::ResourceCreator
    #     def resource_class
    #       OpenStruct  #dont forget to require 'ostruct'
    #     end
    #   end
    #
    # Returns class of Resource to be constructed.
    def resource_class
      Restfolia::Resource
    end

    # Internal: By default, returns :links or :link. You can use
    # this method to override and returns a custom rule, can be an
    # Array or any object that responds to include?.
    #
    # Examples
    #
    #   class Restfolia::ResourceCreator
    #     def attributes_to_dont_parse
    #       [:links, :link, :_links].freeze
    #     end
    #   end
    #
    # Returns attributes to be ignored when creating Resource.
    def attributes_to_dont_parse
      [:links, :link].freeze
    end

    # Internal: Check if value is eligible to become a Restfolia::Resource.
    # It attr_name exist in #attributes_to_dont_parse, it returns value.
    # If value is Array object, looks inner contents, using rules below.
    # If value is Hash object, it becomes a Restfolia::Resource.
    # Else return itself.
    #
    # attr_name  - attribute name from parsed hash.
    # value - object to be checked.
    #
    # Returns value itself or Resource.
    def look_for_resource(attr_name, value)
      return value if attributes_to_dont_parse.include?(attr_name)

      if value.is_a?(Array)
        value = value.inject([]) do |resources, array_obj|
          resources << look_for_resource(attr_name, array_obj)
        end
      elsif value.is_a?(Hash)
        value = resource_class.new(value)
      end
      value
    end

  end

end
