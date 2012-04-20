require "test_helper"

describe Restfolia::EntryPoint do

  include Restfolia::Test::JsonSamples
  include Restfolia::Test::StubHelpers

  subject { Restfolia::EntryPoint.new(Restfolia::Test::FAKE_URL) }

  describe "#get" do

    it "create Resource for valid request" do
      stub_get_request(:status => 200, :body => valid_json)

      resource = subject.get
      resource.must_be_instance_of(Restfolia::Resource)
    end

    it "should accept String params" do
      stub_api = stub_get_request(:status => 200,
                                  :body => valid_json,
                                  :query => {:q => "stringtest",
                                             :p1 => "test"})
      subject.get("q=stringtest&p1=test")
    end

    it "should accept Hash params" do
      stub_api = stub_get_request(:status => 200,
                                  :body => valid_json,
                                  :query => {:q => "hashtest"})
      subject.get(:q => "hashtest")
    end

  end

  describe "#post" do

    it "can post Hash params" do
      headers = {"Content-Type" => "application/json"}
      stub_post_request(:status => 201,
                        :body => "{\"attr_test\":\"test\"}",
                        :headers => headers)

      subject.post(:attr_test => "test")
    end

  end

end
