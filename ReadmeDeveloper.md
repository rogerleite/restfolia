## Steps to generate doc

```
$ gem install yard
$ gem install yard-tomdoc
$ gem install redcarpet
$ yard doc --plugin yard-tomdoc -r Readme.md
# ignore errors :X
$ open doc/index.html
```

## TODO:

EntryPoint
* allow cookies in request

Resource & EntryPoint
* facilitate cache (Cache Control, ETag, Last-Modified)

HTTP Behaviours
* improve 404 and 500 errors
* create librarian-wrappers project

Future Ideas
* Support to JSON HAL
* Another project, to Restfolia be a "Restfulie like". Main mission: migrate old projects
