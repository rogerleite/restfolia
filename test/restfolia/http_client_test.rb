require "test_helper"

describe Restfolia::HttpHelper do

  describe ".query_param" do
    it "should allow nil" do
      Restfolia::HttpHelper.query_param(nil).must_be_nil
    end
    it "should allow String" do
      value = "var=1"
      Restfolia::HttpHelper.query_param(value).must_equal(value)
    end
    it "should support Hash" do
      value = {:var1 => 1}
      Restfolia::HttpHelper.query_param(value).must_equal("var1=1")
    end
    it "should support Hash many keys" do
      value = {:var1 => "1", :var2 => "test"}
      result = Restfolia::HttpHelper.query_param(value)
      result.split("&").size.must_equal 2
    end
  end

  describe ".body_param" do
    it "should bypass String" do
      Restfolia::HttpHelper.body_param(nil, "teste=1").must_equal("teste=1")
    end
    it "should call body method" do
      value = OpenStruct.new(:body => "body=cool")
      Restfolia::HttpHelper.body_param(nil, value).must_equal("body=cool")
    end
    it "should encode if body is Hash" do
      value = {:var => "teste"}
      media_type = Object.new
      def media_type.encode(x)
        x[:var]
      end
      Restfolia::HttpHelper.body_param(media_type, value).must_equal("teste")
    end
    it "should raise error for nil media type" do
      lambda do
        value = {:var => "teste"}
        Restfolia::HttpHelper.body_param(nil, value)
      end.must_raise(ArgumentError)
    end
    it "should raise for invalid body" do
      lambda do
        Restfolia::HttpHelper.body_param(nil, nil)
      end.must_raise(ArgumentError)
      lambda do
        Restfolia::HttpHelper.body_param(nil, Object.new)
      end.must_raise(ArgumentError)
    end
  end

end
