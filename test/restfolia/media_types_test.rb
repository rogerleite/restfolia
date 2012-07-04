require "test_helper"

describe Restfolia::MediaTypes::Json do

  subject { Restfolia::MediaTypes::Json.new }

  it "#encode" do
    subject.encode(:test => "value").must_equal("{\"test\":\"value\"}")
  end

  it "#decode" do
    subject.decode("{\"test\":\"value\"}").must_equal(:test => "value")
  end

  it "#decode invalid json" do
    lambda do
      subject.decode("<html>error</html>")
    end.must_raise(Restfolia::MediaTypes::DecodeError)
  end

end

describe Restfolia::MediaTypes::Bypass do

  subject { Restfolia::MediaTypes::Bypass.new }

  it "should bypass all values" do
    subject.encode("<html>test</html>").must_equal("<html>test</html>")
    subject.decode("<html>test</html>").must_equal("<html>test</html>")
  end

end

describe Restfolia::MediaTypes::DecodeError do

  it "should store value error" do
    error = Restfolia::MediaTypes::DecodeError.new("msg", caller, "value")
    error.value.must_equal("value")
  end

end
