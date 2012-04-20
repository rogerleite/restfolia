module Restfolia::Test
  module StubHelpers

    def stub_get_request(args = {})
      status = args[:status]
      body = args[:body]
      query = args[:query]

      headers = {"Content-Type" => "application/json"}
      stub = stub_request(:get, Restfolia::Test::FAKE_URL)
      stub.with(:query => query) unless query.nil?
      stub.to_return(:body => body,
                     :status => status,
                     :headers => headers)
    end

    def stub_post_request(args = {})
      status = args[:status]
      body = args[:body]
      headers = args[:headers]

      stub_request(:post, Restfolia::Test::FAKE_URL).
        with(:body => body,
             :headers => {'Accept'=>'*/*'}).
             to_return(:status => status,
                       :body => "",
                       :headers => headers)
    end

  end
end
