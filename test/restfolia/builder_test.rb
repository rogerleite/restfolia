require "test_helper"

describe Restfolia::Builder do

  subject { Restfolia::Builder.new }

  it "#media_types" do
    subject.media_types.must_be_instance_of(Restfolia::MediaTypeCollection)
  end

  it "#behaviours" do
    subject.behaviours.must_be_instance_of(Restfolia::BehaviourCollection)
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
end

describe Restfolia::MediaTypeCollection do

  subject { Restfolia::MediaTypeCollection.new }

  it "#register" do
    obj = Object.new
    puts subject.inspect
    subject.register "application/json", obj

    subject.find("application/json").must_be_same_as(obj)
  end
end
