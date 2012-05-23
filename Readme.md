![Logo Restfolia][logo_readme]
# Restfolia [![Build Status][travis_status]][travis]

[logo_readme]: http://rogerleite.github.com/restfolia/images/logo_readme.png
[travis_status]: https://secure.travis-ci.org/rogerleite/restfolia.png
[travis]: http://travis-ci.org/rogerleite/restfolia

REST client to consume and interact with Hypermedia API, using JSON as Media Type.

## Description

Restfolia is a REST client and it's main goal is help you **consume and interact** with Hypermedia APIs.

Against the grain, Restfolia is very opinionated about some REST's concepts:

* Aims only **JSON Media Type**.
* All responses are parsed and returned as Restfolia::Resource.
* Less is more. Restfolia is very proud to be small, easy to maintain and evolve. You can compare Restfolia's code with "Similar Projects" at page's bottom.
* Restfolia::Resource is Ruby object with attributes from JSON and can optionally contains **hypermedia links** which have to be a specific format. See the examples below.
* All code is very well documented, using [TomDoc](http://tomdoc.org style).

Obs: This is a draft version. Not ready for production (yet!).

## References

You can find more information about arquitecture REST below:

* [Roy Fielding's](http://roy.gbiv.com/untangled) see this post for example: [REST APIs must be hypertext-driven](http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven).
* [Rest in Practice](http://restinpractice.com), especially the chapter titled "Hypermedia Formats".
* [Mike Amundsen's Blog](http://amundsen.com/blog)
* ROAR - [Resource Oriented Arquitectures in Ruby](https://github.com/apotonick/roar) it seems really good to build a hypermedia API, of course you can go with Sinatra+rabl solutions too.

## Examples of use

```js
// GET http://localhost:9292/recursos/busca
{ "itens_por_pagina" : 10,
  "paginal_atual" : 1,
  "paginas_totais" : 1,
  "query" : "",
  "total_resultado" : 100,
  "resultado" : [ { "id" : 1,
                    "name" : "Test1",
                    "links" : [ { "href" : "http://localhost:9292/recursos/id/1",
                          "rel" : "recurso",
                          "type" : "application/json"
                    } ]
                  },
                  { "id" : 2,
                    "name" : "Test2",
                    "links" : [ { "href" : "http://localhost:9292/recursos/id/2",
                          "rel" : "recurso",
                          "type" : "application/json"
                    } ]
                  }
                ],
  "links" : { "href" : "http://localhost:9292/recursos/busca",
      "rel" : "self",
      "type" : "application/json"
    },
}
```

```js
// GET http://localhost:9292/recursos/id/1
{ "id"    : 1,
  "name"  : "Test1",
  "links" : { "href" : "http://localhost:9292/recursos/id/1",
              "rel" : "self",
              "type" : "application/json"
            }
}
```

```ruby
# getting a resource
resource = Restfolia.at('http://localhost:9292/recursos/busca').get
resource.pagina_atual  # => 1
resource.resultado  # => [#<Resource ...>, #<Resource ...>]

# example of hypermedia navigation
r1 = resource.resultado.first
r1 = r1.links("recurso").get  # => #<Resource ...>
r1.name  # => "Test1"
```

## Similar Projects

* [ROAR](https://github.com/apotonick/roar)
* [Leadlight](https://github.com/avdi/leadlight)
* [Frenetic](https://github.com/dlindahl/frenetic)
* [Restfulie](https://github.com/caelum/restfulie)

## What is "folia"?

Folia is a portuguese word and a simple translation in English can be:

> sf merry-making, merriment, revelry. que folia! what a fun!

## License

Restfolia is copyright 2012 Roger Leite and contributors. It is licensed under the MIT license. See the include MIT-LICENSE file for details.

