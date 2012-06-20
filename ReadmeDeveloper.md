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

## TODO:

Improvements:

* Add "events" before and after request. This could be
cool to make projects that extends Restfolia features.

Resource & EntryPoint

* facilitate cache (Cache Control, ETag, Last-Modified).
This could be another project like restfolia-cazuza.

Future Ideas

* Support to JSON HAL
* Another project, to Restfolia be a "Restfulie like". Main mission: migrate old projects
