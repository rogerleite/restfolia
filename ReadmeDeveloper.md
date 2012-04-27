## Steps to generate doc

```
# dependencies
$ gem install yard
$ gem install yard-tomdoc
$ gem install redcarpet

# use params from .yardopts file
$ yard
$ open doc/index.html
```
**Obs:** ignore errors :X, until my [pull request](https://github.com/rubyworks/yard-tomdoc/pull/5) be accepted.

## TODO:

Improvements:

* Centralize in one Place, Resource creation

Resource & EntryPoint

* facilitate cache (Cache Control, ETag, Last-Modified)

HTTP Behaviours

* improve 404 and 500 errors
* create librarian-wrappers project

Future Ideas

* Support to JSON HAL
* Another project, to Restfolia be a "Restfulie like". Main mission: migrate old projects
