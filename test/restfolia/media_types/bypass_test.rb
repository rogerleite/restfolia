require "test_helper"

describe Restfolia::MediaTypes::Bypass do

  subject { Restfolia::MediaTypes::Bypass.new }

  it "should bypass all values" do
    subject.encode("<html>test</html>").must_equal("<html>test</html>")
    subject.decode("<html>test</html>").must_equal("<html>test</html>")
  end

end
