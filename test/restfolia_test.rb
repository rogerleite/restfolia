require "test_helper"

describe Restfolia do

  it ".url" do
    ep = Restfolia.at("http://fakeurl.com")
    ep.must_be_instance_of(Restfolia::EntryPoint)
  end

end
