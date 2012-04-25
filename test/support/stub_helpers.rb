module Restfolia::Test
  module StubHelpers

    def stub_get_request(args = {})
      status = args[:status]
      body = args[:body]
      query = args[:query]
      headers = args[:headers] || {}
      headers["Content-Type"] = "application/json"
      with_headers = args[:with_headers]

      stub = stub_request(:get, Restfolia::Test::FAKE_URL)
      stub.with(:query => query) unless query.nil?
      stub.with(:headers => with_headers) unless with_headers.nil?

      stub.to_return(:body => body,
                     :status => status,
                     :headers => headers)
    end

    def stub_method_request(method, args = {})
      status = args[:status]
      body = args[:body]
      headers = args[:headers]
      with_headers = args[:with_headers] || {'Accept'=>'*/*'}

      stub_request(method, Restfolia::Test::FAKE_URL).
        with(:body => body,
             :headers => with_headers).
             to_return(:status => status,
                       :body => "",
                       :headers => headers)
    end

  end
end
