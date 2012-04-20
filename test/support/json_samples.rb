module Restfolia::Test

  FAKE_URL = "http://fakeurl.com"
  FAKE_LOCATION_URL = "http://fakeurl.com/resource/666"

  module JsonSamples


    def valid_json
      json_body = <<json_body
{ "itens_por_pagina" : 10,
  "links" : { "href" : "http://localhost:9292/recursos/busca",
      "rel" : "self",
      "type" : "application/json"
    },
  "paginal_atual" : 1,
  "paginas_totais" : 1,
  "query" : "",
  "resultado" : [ { "id" : 1,
        "links" : [ { "href" : "http://localhost:9292/recursos/id/1",
              "rel" : "recurso",
              "type" : "application/json"
            } ],
        "name" : "Test1"
      },
      { "id" : 2,
        "links" : [ { "href" : "http://localhost:9292/recursos/id/2",
              "rel" : "recurso",
              "type" : "application/json"
            } ],
        "name" : "Test2"
      }
    ],
  "total_resultado" : 100
}
json_body
    end

  end

end
