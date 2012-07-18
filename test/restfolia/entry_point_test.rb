require "test_helper"

describe Restfolia::EntryPoint do

  FAKE_URL = "http://fake.com/service"

  before do
    @mock_client = stub("client")
  end

  subject do
    Restfolia::EntryPoint.new(@mock_client, FAKE_URL)
  end

  it "#get" do
    subject.expects(:client_options).with(:query => "q=1").returns("mock")
    @mock_client.expects(:http_request).with(:get, FAKE_URL, "mock")
    subject.get("q=1")
  end
  it "#post" do
    subject.expects(:client_options).with(:body => "b=1").returns("mock")
    @mock_client.expects(:http_request).with(:post, FAKE_URL, "mock")
    subject.post("b=1")
  end
  it "#put" do
    subject.expects(:client_options).with(:body => "b=1").returns("mock")
    @mock_client.expects(:http_request).with(:put, FAKE_URL, "mock")
    subject.put("b=1")
  end
  it "#delete" do
    subject.expects(:client_options).returns("mock")
    @mock_client.expects(:http_request).with(:delete, FAKE_URL, "mock")
    subject.delete
  end
  describe "#client_options" do
    it "query param" do
      Restfolia::HttpHelper.expects(:query_param).with("q").returns("OK")
      subject.stubs(:request_options).returns({})

      result = subject.send(:client_options, {:query => "q"})
      result[:query].must_equal "OK"
    end
    it "body param" do
      media_type = stub("media_type")
      subject.expects(:media_type).with({:h => "1"}).returns(media_type)
      Restfolia::HttpHelper.expects(:body_param).with(media_type, "b").returns("OK")
      subject.stubs(:request_options).returns({:headers => {:h => "1"}})

      result = subject.send(:client_options, {:body => "b"})
      result[:body].must_equal "OK"
    end
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
