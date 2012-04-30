require "test_helper"

describe Restfolia::HTTP::Behaviour do

  include Restfolia::Test::JsonSamples
  include Restfolia::Test::StubHelpers

  before do
    @http_mock = MiniTest::Mock.new
    Restfolia::HTTP::Behaviour.extend(Restfolia::HTTP::Behaviour)
  end

  subject { Restfolia::EntryPoint.new(Restfolia::Test::FAKE_URL) }

  describe "#response_by_status_code" do
    it "should raise Error for http code diferent from 2xx,3xx,4xx and 5xx" do
      @http_mock.expect(:code, "999")
      lambda do
        Restfolia::HTTP::Behaviour.response_by_status_code(@http_mock)
      end.must_raise(RuntimeError)
    end
  end

  describe "#on_2xx" do

    it "should validate Content-Type header" do
      @http_mock.expect(:[], "invalid/type", ["content-type"])
      lambda do
        Restfolia::HTTP::Behaviour.on_2xx(@http_mock)
      end.must_raise(Restfolia::ResponseError)
    end

    it "should validate invalid body" do
      @http_mock.expect(:[], "application/json", ["content-type"])
      @http_mock.expect(:body, '<html><body>error fake</body></html>')
      lambda do
        Restfolia::HTTP::Behaviour.on_2xx(@http_mock)
      end.must_raise(Restfolia::ResponseError)
    end

    it "should return Resource for HTTP Response with valid body" do
      @http_mock.expect(:[], "application/json", ["content-type"])
      @http_mock.expect(:body, '{"attr_test": "test"}')

      value = Restfolia::HTTP::Behaviour.on_2xx(@http_mock)
      value.must_be_instance_of(Restfolia::Resource)
    end

    it "should return Resource for HTTP Response when content-type is 'application/json; charset=utf-8'" do
      @http_mock.expect(:[], "application/json; charset=utf-8", ["content-type"])
      @http_mock.expect(:body, '{"attr_test": "test"}')

      value = Restfolia::HTTP::Behaviour.on_2xx(@http_mock)
      value.must_be_instance_of(Restfolia::Resource)
    end

    it "should return Resource for HTTP Response with Location header" do
      @http_mock.expect(:code, "201")
      @http_mock.expect(:body, nil)
      @http_mock.expect(:[], "application/json", ["content-type"])
      @http_mock.expect(:[], Restfolia::Test::FAKE_LOCATION_URL, ["location"])

      stub_request(:get, Restfolia::Test::FAKE_LOCATION_URL).
        to_return(:body => valid_json,
                  :status => 200,
                  :headers => {"Content-Type" => "application/json"})

      value = Restfolia::HTTP::Behaviour.on_2xx(@http_mock)
      value.must_be_instance_of(Restfolia::Resource)
    end

  end

  describe "#on_3xx" do

    it "follows Location Header" do
      headers = {:location => Restfolia::Test::FAKE_LOCATION_URL}
      stub_request(:get, Restfolia::Test::FAKE_LOCATION_URL).
        to_return(:body => valid_json,
                  :status => 200,
                  :headers => {"Content-Type" => "application/json"})

      stub_get_request(:status => 300, :body => "", :headers => headers)

      resource = subject.get
      resource.must_be_instance_of(Restfolia::Resource)
    end

    it "raise Error for 3xx without location header" do
      stub_get_request(:status => 300, :body => "")
      lambda { subject.get }.must_raise(Restfolia::ResponseError)
    end

  end

  describe "#on_4xx" do

    it "raise Error for 401 status" do
      stub_get_request(:status => 401, :body => "")
      request = lambda { subject.get }
      error = request.call rescue $!

      request.must_raise(Restfolia::ResponseError)
      error.http_message.must_equal 'Unauthorized'
    end

    it "raise Error for 404 status" do
      stub_get_request(:status => 404, :body => "")
      request = lambda { subject.get }
      error = request.call rescue $!

      request.must_raise(Restfolia::ResponseError)
      error.http_message.must_equal 'Not Found'
    end

  end

  describe "#on_5xx" do

    it "raise Error for 5xx status" do
      stub_get_request(:status => 500, :body => "")
      lambda { subject.get }.must_raise(Restfolia::ResponseError)
    end

  end

end
