module Restfolia::Resources

  # Public: Know how to identify Hash objects in Array or Hash structures.
  #
  # Examples
  #
  #    creator = Restfolia::Resources::HashCrawler.new
  #    resource = creator.create(:attr_test => "test") do |hash|
  #      OpenStruct.new(hash)
  #    end
  #    resource.attr_test # => "test"
  #    resource.inspect # => #<OpenStruct ...>
  class HashCrawler

    # Sets/Returns attributes to be ignored when invoking resource creator block.
    # Examples
    #    crawler.attributes_to_dont_parse = [:links, :link, 'links', 'link']
    attr_accessor :attributes_to_dont_parse

    def initialize
      self.attributes_to_dont_parse = []
    end

    # Public: Identify Hash objects in Array or Hash structures.
    #
    # object - Hash or Array of hashes, parsed from Response body.
    # resource_creator - An obligatory block that can be used to transform
    # yielded hash objects to anything you want.
    #
    # Examples
    #
    #    creator = Restfolia::Resources::HashCrawler.new
    #    resource = creator.create(:attr_test => "test") do |hash|
    #      OpenStruct.new(hash)
    #    end
    #    resource.attr_test # => "test"
    #    resource.inspect # => #<OpenStruct ...>
    #
    # Returns if object is Array, returns Array of Resources.
    # if object is Hash, Resource.
    #
    # Raises ArgumentError if block not informed.
    # Raises ArgumentError if object is not a Hash or Array.
    def create(object, &resource_creator)

      @resource_creator = resource_creator
      if resource_creator.nil?
        raise(ArgumentError, "resource creator block is obligatory", caller)
      end

      if object.is_a?(Array)
        object.inject([]) do |result, hash|
          result << create_resource(hash)
        end
      elsif object.is_a?(Hash)
        create_resource(object)
      else
        raise(ArgumentError, "object parameter have to be a Hash or Array object", caller)
      end
    end

    protected

    def create_resource(hash)
      unless hash.kind_of?(Hash)
        msg = "Parameter have to be a Hash object. #{hash.class.inspect}"
        raise(ArgumentError, msg, caller)
      end

      hash_crawled = {}
      hash.each do |attr, value|
        hash_crawled[attr] = look_for_resource(attr, value)
      end
      @resource_creator.call(hash_crawled)
    end

    # Internal: Check if value is eligible to become a Resource.
    # It attr_name exist in #attributes_to_dont_parse, it returns value.
    # If value is Array object, looks inner contents, applying these rules.
    # If value is Hash object, looks inner contents (using this rules)
    # and it becomes a Resource.
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
        value.each do |attr, v|
          value[attr] = look_for_resource(attr, v)
        end
        value = @resource_creator.call(value)
      end
      value
    end

  end

end
