require "test_helper"
require "ostruct"

describe Restfolia::Resources::HashCrawler do

  let(:resource_creator) { lambda {|hash| OpenStruct.new(hash)} }
  subject { Restfolia::Resources::HashCrawler.new }

  describe "#create" do
    it "accept only hash object as parameter" do
      lambda do
        subject.create(nil, &resource_creator)
      end.must_raise(ArgumentError)
    end
    it "block is obligatory" do
      lambda do
        subject.create(:attr1 => "test")
      end.must_raise(ArgumentError)
    end
    it "should create Resource for simple hash" do
      resource = subject.create({:attr_test => "test"}, &resource_creator)
      resource.must_be_instance_of(OpenStruct)
    end
    it "transforms nested hash in Resource" do
      resource = subject.create({:attr_test => {:nested => "nested"}}, &resource_creator)
      resource.attr_test.must_be_instance_of(OpenStruct)
      resource.attr_test.nested.must_equal("nested")
    end
    it "transforms nested hash from Arrays in Resource" do
      resource = subject.create({:attr_test => [{:nested_array => "object"}],
                                 :attr_test2 => ["not object"]}, &resource_creator)

      resource.attr_test.must_be_instance_of(Array)
      resource.attr_test[0].must_be_instance_of(OpenStruct)
      resource.attr_test[0].nested_array.must_equal("object")

      resource.attr_test2[0].must_be_instance_of(String)
      resource.attr_test2[0].must_equal("not object")
    end
    it "transforms nested hash from nested Array from Array in Resource" do
      hash = {:attr_test => [[{:nested => "nested2"}]]}
      resource = subject.create(hash, &resource_creator)

      resource.attr_test.must_be_instance_of(Array)
      resource.attr_test[0].must_be_instance_of(Array)
      resource.attr_test[0][0].must_be_instance_of(OpenStruct)
      resource.attr_test[0][0].nested.must_equal("nested2")
    end
    it "transforms multiple levels of hash" do
      resource = subject.create({:slug => "4fb15a526f32412f37000012",
                                :hash1 => {
                                  :hash2 => {
                                    :link => [
                                      {:href => "http://exemplo.com",
                                       :rel => "interno",
                                       :type => "image/jpeg"
                                    }
                                    ],
                                      :origem => "sistema",
                                      :hash3 => {
                                        :test => "test"
                                      }
                                  }
                                }}, &resource_creator)

                                resource.slug.must_equal("4fb15a526f32412f37000012")
                                resource.hash1.must_be_instance_of(OpenStruct)
                                resource.hash1.hash2.must_be_instance_of(OpenStruct)
                                resource.hash1.hash2.origem.must_equal("sistema")
                                resource.hash1.hash2.hash3.must_be_instance_of(OpenStruct)
    end
    it "supports Array of hashes" do
      resource = subject.create([{:slug => "slug1"}, {:slug => "slug2"}], &resource_creator)

      resource.must_be_instance_of(Array)
      resource[0].slug.must_equal("slug1")
      resource[1].slug.must_equal("slug2")
    end
  end

  describe "#attributes_to_dont_parse" do
    it "don't transforms nested link hash in Resource" do
      subject.attributes_to_dont_parse = ['link']
      hash = {'link' => {:rel => "nested",:href => "http://localhost"}}
      resource = subject.create(hash, &resource_creator)
      resource.link.must_be_instance_of(Hash)
    end
    it "should not parse if attribute is on attributes_to_dont_parse" do
      subject.attributes_to_dont_parse = [:to_ignore]
      resource = subject.create({:attr_test => {:nested => "nested"},
                                 :to_ignore => {:rel => "test"}}, &resource_creator)
      resource.must_be_instance_of(OpenStruct)
      resource.to_ignore.must_be_instance_of(Hash)
    end
  end

end
