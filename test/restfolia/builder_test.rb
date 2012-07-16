require "test_helper"

describe Restfolia::Builder::ClientBuilder do

  subject { Restfolia::Builder::ClientBuilder.new }

  it "#media_types" do
    subject.media_types.must_be_instance_of(Restfolia::Builder::MediaTypeCollection)
  end

  it "#behaviours" do
    subject.behaviours.must_be_instance_of(Restfolia::Builder::BehaviourCollection)
  end

  it "#http_client" do
    subject.must_respond_to(:http_client)
  end

end
