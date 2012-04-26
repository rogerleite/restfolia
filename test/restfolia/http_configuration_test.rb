require "test_helper"

describe Restfolia::HTTP::Configuration do

  class TestConfiguration; include Restfolia::HTTP::Configuration; end

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

  it "#cookies" do
    @object.must_respond_to(:cookies)
  end

  it "#set_cookies" do
    expected_cookies = "key=value;"
    return_value = @object.set_cookies(expected_cookies)

    @object.must_be_same_as(return_value)
    @object.cookies.must_equal(expected_cookies)
  end

end
