require "test_helper"

describe Restfolia::EntryPoint do

  FAKE_URL = "http://fake.com/service"

  before do
    @mock_client = MiniTest::Mock.new
  end

  subject do
    Restfolia::EntryPoint.new(@mock_client, FAKE_URL)
  end

  describe "#get" do
    it "should accept blank query" do
      mock_params = [:get, FAKE_URL, {:query => nil,
                                      :headers => {},
                                      :cookies => nil}]
      @mock_client.expect(:http_request, "ok", mock_params)
      subject.get.must_equal("ok")
    end

    it "should delegate query param as is" do
      mock_params = [:get, FAKE_URL, {:query => "test=true",
                                      :headers => {},
                                      :cookies => nil}]
      @mock_client.expect(:http_request, "ok", mock_params)
      subject.get("test=true").must_equal("ok")
    end
  end

  it "#post" do
    mock_params = [:post, FAKE_URL, {:body => "body",
                                     :headers => {},
                                     :cookies => nil}]
    @mock_client.expect(:http_request, "ok", mock_params)
    subject.post("body").must_equal("ok")
  end

  it "#put" do
    mock_params = [:put, FAKE_URL, {:body => "body",
                                    :headers => {},
                                    :cookies => nil}]
    @mock_client.expect(:http_request, "ok", mock_params)
    subject.put("body").must_equal("ok")
  end

  it "#delete" do
    mock_params = [:delete, FAKE_URL, {:headers => {}, :cookies => nil}]
    @mock_client.expect(:http_request, "ok", mock_params)
    subject.delete.must_equal("ok")
  end

end

describe Restfolia::RequestOptions do

  class TestRequestOptions
    include Restfolia::RequestOptions
  end

  before do
    @expected_headers = {"Content-Type" => "application/json"}
  end

  subject { TestRequestOptions.new }

  it "#headers" do
    subject.headers["Content-Type"] = "application/json"
    subject.headers.must_equal(@expected_headers)
    subject.request_options[:headers].must_equal(@expected_headers)
  end

  it "#with_headers" do
    return_value = subject.with_headers("Content-Type" => "application/json")

    subject.must_be_same_as(return_value)
    subject.headers.must_equal(@expected_headers)
    subject.request_options[:headers].must_equal(@expected_headers)
  end

  it "#as" do
    expected_headers = {"Content-Type" => "application/json",
                        "Accept" => "application/json"}
    return_value = subject.as("application/json")

    subject.must_be_same_as(return_value)
    subject.headers.must_equal(expected_headers)
    subject.request_options[:headers].must_equal(expected_headers)
  end

  it "#cookies" do
    subject.must_respond_to(:cookies)
  end

  it "#set_cookies" do
    expected_cookies = "key=value;"
    return_value = subject.set_cookies(expected_cookies)

    subject.must_be_same_as(return_value)
    subject.cookies.must_equal(expected_cookies)
    subject.request_options[:cookies].must_equal(expected_cookies)
  end

end
