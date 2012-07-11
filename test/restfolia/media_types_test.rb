require "test_helper"

describe Restfolia::MediaTypes::DecodeError do
  it "should store value error" do
    error = Restfolia::MediaTypes::DecodeError.new("msg", caller, "value")
    error.value.must_equal("value")
  end
end
