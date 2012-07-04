require "test_helper"

describe Restfolia::Builder do

  subject { Restfolia::Builder.new }

  it "#media_types" do
    subject.media_types.must_be_instance_of(Restfolia::MediaTypeCollection)
  end

  it "#behaviours" do
    subject.behaviours.must_be_instance_of(Restfolia::BehaviourCollection)
  end

  it "#http_client" do
    subject.must_respond_to(:http_client)
  end

end

describe Restfolia::BehaviourCollection do

  subject { Restfolia::BehaviourCollection.new }

  describe "#on" do
    it "support Integer code" do
      subject.on(1) { "test int" }

      subject.find(1).call.must_equal("test int")
      subject.find(2).must_be_nil
    end
    it "support Range code" do
      subject.on(90...100) { "test range" }

      subject.find(90).call.must_equal("test range")
      subject.find(99).call.must_equal("test range")
      subject.find(100).must_be_nil
    end
    it "support Array code (or anything that respond_to include?)" do
      subject.on([2,3]) { "test array" }

      subject.find(2).call.must_equal("test array")
      subject.find(3).call.must_equal("test array")
      subject.find(1).must_be_nil
    end
  end

  it "#on_unknown" do
    subject.on_unknown { "ok" }
    subject.unknown_behaviour.call.must_equal("ok")
  end
end

describe Restfolia::MediaTypeCollection do

  subject { Restfolia::MediaTypeCollection.new }

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
