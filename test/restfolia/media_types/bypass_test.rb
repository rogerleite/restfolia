require "test_helper"

describe Restfolia::MediaTypes::Bypass do

  subject { Restfolia::MediaTypes::Bypass.new }

  it "should bypass all values" do
    subject.encode("<html>test</html>").must_equal("<html>test</html>")
    subject.decode("<html>test</html>").must_equal("<html>test</html>")

    http_response = OpenStruct.new(:body => "<html>test</html>")
    subject.create_resource(nil, http_response).must_equal("<html>test</html>")
  end

end
