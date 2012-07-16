require "test_helper"

describe Restfolia::Builder::MediaTypeCollection do

  subject { Restfolia::Builder::MediaTypeCollection.new }

  it "#register" do
    obj = Object.new
    subject.register "application/json", obj

    subject.find("application/json").must_be_same_as(obj)
  end

  describe "#default" do
    it "first register is default" do
      obj1 = Object.new
      obj2 = Object.new
      subject.register "application/app2", obj2
      subject.register "application/app1", obj1

      subject.default.must_equal(["application/app2", obj2])
    end
    it "can mark some register to be default" do
      obj1 = Object.new
      obj2 = Object.new
      subject.register "application/app2", obj2
      subject.register "application/app1", obj1, :default => true

      subject.default.must_equal(["application/app1", obj1])
    end
  end
end

