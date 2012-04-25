require "net/http"
require "uri"

require "rubygems"
require "multi_json"

require "restfolia/version"
require "restfolia/http/behaviour"
require "restfolia/http/configuration"
require "restfolia/entry_point"
require "restfolia/resource"

# Public: Restfolia: a REST client to consume and interact with Hypermedia API.
#
# Against the grain, Restfolia is very opinionated about some REST's concepts:
# * Aims only *JSON Media Type*.
# * All responses are parsed and returned as Restfolia::Resource.
# * Less is more. Restfolia is very proud to be small, easy to maintain and evolve.
# * Restfolia::Resource is Ruby object with attributes from JSON and can optionally contains *hypermedia links* which have to be a specific format. See the examples below.
# * All code is very well documented, using "TomDoc":http://tomdoc.org style.
#
# Obs: This is a draft version. Not ready for production (yet!).
#
# References
#
# You can find more information about arquitecture REST below:
# * "Roy Fielding's":http://roy.gbiv.com/untangled see this post for example: "REST APIs must be hypertext-driven":http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven
# * "Rest in Practice":http://restinpractice.com, especially the chapter titled "Hypermedia Formats".
# * "Mike Amundsen's Blog":http://amundsen.com/blog/
# * ROAR - "Resource Oriented Arquitectures in Ruby":https://github.com/apotonick/roar it seems really good to build a hypermedia API, of course you can go with Sinatra+rabl solutions too.
#
# Examples
#
#   # GET http://localhost:9292/recursos/busca
#   { "itens_por_pagina" : 10,
#     "paginal_atual" : 1,
#     "paginas_totais" : 1,
#     "query" : "",
#     "total_resultado" : 100,
#     "resultado" : [ { "id" : 1,
#                       "name" : "Test1",
#                       "links" : [ { "href" : "http://localhost:9292/recursos/id/1",
#                             "rel" : "recurso",
#                             "type" : "application/json"
#                       } ]
#                     },
#                     { "id" : 2,
#                       "name" : "Test2",
#                       "links" : [ { "href" : "http://localhost:9292/recursos/id/2",
#                             "rel" : "recurso",
#                             "type" : "application/json"
#                       } ]
#                     }
#                   ],
#     "links" : { "href" : "http://localhost:9292/recursos/busca",
#         "rel" : "self",
#         "type" : "application/json"
#       },
#   }
#
#   # GET http://localhost:9292/recursos/id/1
#   { "id"    : 1,
#     "name"  : "Test1",
#     "links" : { "href" : "http://localhost:9292/recursos/id/1",
#                 "rel" : "self",
#                 "type" : "application/json"
#               }
#   }
#
#   # getting a resource
#   resource = Restfolia.at('http://localhost:9292/recursos/busca').get
#   resource.pagina_atual  # => 1
#   resource.resultado  # => [#<Resource ...>, #<Resource ...>]
#
#   # example of hypermedia navigation
#   r1 = resource.resultado.first
#   r1 = r1.links("recurso").get  # => #<Resource ...>
#   r1.name  # => "Test1"
#
module Restfolia

  # Public: Start point for getting the first Resource.
  #
  # url - String with the address of service to be accessed.
  #
  # Examples
  #
  #   entry_point = Restfolia.at("http://localhost:9292/recursos/busca")
  #   entry_point.get # => #<Resource ...>
  #
  # Returns Restfolia::EntryPoint object.
  def self.at(url)
    EntryPoint.new(url)
  end

end
