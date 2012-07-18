require "test_helper"

describe Restfolia::Client do

  before do
    @mock_builder = stub("builder")
  end

  subject { Restfolia::Client.new(@mock_builder) }

  it "#at" do
    subject.at("http://f.com/srv").must_be_instance_of(Restfolia::EntryPoint)
  end

  it "#configure without block" do
    result = subject.configure
    result.must_equal @mock_builder
  end
  it "#configure with block" do
    @mock_builder.expects(:behaviours)
    result = subject.configure do
      behaviours
    end
    result.must_equal @mock_builder
  end

  describe "#http_request" do

    subject do
      builder = Restfolia::Builder::ClientBuilder.new
      builder.media_types.register("application/json", Restfolia::MediaTypes::Bypass.new)
      builder.behaviours.on_unknown do |http_response, media_type, client|
        "default flow ok"  #media_type.decode(http_response.body.to_s)
      end
      Restfolia::Client.new(builder)
    end

    it "default flow should work" do
      VCR.use_cassette('recursos_busca') do
        value = subject.http_request(:get, "http://localhost:9292/recursos/busca")
        value.must_equal("default flow ok")
      end
    end

  end

end
