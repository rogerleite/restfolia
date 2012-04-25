require "test_helper"

describe Restfolia::HTTPConfiguration do

  class TestConfiguration; include Restfolia::HTTPConfiguration; end

  before do
    @object = TestConfiguration.new
    @expected_headers = {"Content-Type" => "application/json"}
  end

  it "#headers" do
    @object.headers["Content-Type"] = "application/json"
    @object.headers.must_equal(@expected_headers)
  end

  it "#with_headers" do
    return_value = @object.with_headers("Content-Type" => "application/json")

    @object.must_be_same_as(return_value)
    @object.headers.must_equal(@expected_headers)
  end

  it "#as" do
    expected_headers = {"Content-Type" => "application/json",
                        "Accept" => "application/json"}
    return_value = @object.as("application/json")

    @object.must_be_same_as(return_value)
    @object.headers.must_equal(expected_headers)
  end

end
