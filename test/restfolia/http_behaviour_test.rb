require "test_helper"

describe Restfolia::HTTP::Behaviour do

  describe "Store" do
    subject { Restfolia::HTTP::Behaviour::Store.new }

    describe "#execute" do
      before do
        @http_mock = MiniTest::Mock.new
      end

      it "should execute block for Integer code match" do
        @http_mock.expect(:code, "200")
        subject.on(200) { 'test' }

        return_value = subject.execute(@http_mock)
        return_value.must_equal('test')
      end

      it "should execute block for Range code match" do
        @http_mock.expect(:code, "300")
        subject.on(300...400) { 'test' }

        return_value = subject.execute(@http_mock)
        return_value.must_equal('test')
      end

      it "should execute block for Array code match" do
        @http_mock.expect(:code, "404")
        subject.on([404, 403]) { 'test' }

        return_value = subject.execute(@http_mock)
        return_value.must_equal('test')
      end

      it "should call #default_behaviour for non match code" do
        http_mock = Object.new
        http_mock.instance_eval { def code; "666"; end }

        lambda { subject.execute(http_mock) }.
          must_raise(Restfolia::ResponseError)
      end
    end

    describe "#behaviours" do
      it "should be possible to call 'on' method" do
        subject.behaviours do
          on(200) { 'test' }
        end
      end
    end

    it "#helpers" do
      subject.must_respond_to(:helpers)
      subject.helpers.must_be_instance_of(Restfolia::HTTP::Behaviour::Helpers)
    end

  end

  describe "Helpers" do

    subject { Restfolia::HTTP::Behaviour::Helpers.new }

    before do
      @http_mock = MiniTest::Mock.new
    end

    describe "#parse_json" do
      it "should returns parsed json" do
        json_sample = '{"test":"ok"}'
        @http_mock.expect(:body, json_sample)
        json = subject.parse_json(@http_mock)

        json.must_be_instance_of(Hash)
        json[:test].must_equal("ok")
      end
      it "should raise error for invalid body" do
        @http_mock.expect(:body, "<html><body>error</body></html>")
        lambda do
          subject.parse_json(@http_mock)
        end.must_raise(Restfolia::ResponseError)
      end
    end

  end

end
