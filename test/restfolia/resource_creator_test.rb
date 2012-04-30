require "test_helper"
require "ostruct"

describe Restfolia::ResourceCreator do

  let(:subject) do
    creator = Restfolia::ResourceCreator.new
    def creator.resource_class
      OpenStruct
    end
    creator
  end

  describe ".create" do

    it "accept only hash object as parameter" do
      lambda { subject.create(nil) }.must_raise(ArgumentError)
    end

    it "should create Resource for simple hash" do
      resource = subject.create(:attr_test => "test")
      resource.must_be_instance_of(OpenStruct)
    end

    it "transforms nested hash in Resource" do
      resource = subject.create(:attr_test => {:nested => "nested"})
      resource.attr_test.must_be_instance_of(OpenStruct)
      resource.attr_test.nested.must_equal("nested")
    end

    it "transforms nested hash from Arrays in Resource" do
      resource = subject.create(:attr_test => [{:nested_array => "object"}],
                                :attr_test2 => ["not object"])

      resource.attr_test.must_be_instance_of(Array)
      resource.attr_test[0].must_be_instance_of(OpenStruct)
      resource.attr_test[0].nested_array.must_equal("object")

      resource.attr_test2[0].must_be_instance_of(String)
      resource.attr_test2[0].must_equal("not object")
    end

    it "transforms nested hash from nested Array from Array in Resource" do
      resource = subject.create(:attr_test => [[{:nested => "nested2"}]])

      resource.attr_test.must_be_instance_of(Array)
      resource.attr_test[0].must_be_instance_of(Array)
      resource.attr_test[0][0].must_be_instance_of(OpenStruct)
      resource.attr_test[0][0].nested.must_equal("nested2")
    end

  end

end
