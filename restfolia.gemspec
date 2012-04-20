# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "restfolia/version"

Gem::Specification.new do |s|
  s.name        = "restfolia"
  s.version     = Restfolia::VERSION
  s.authors     = ["Roger Leite"]
  s.email       = ["roger.barreto@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Simplest library ever for getting json from http requests}
  s.description = %q{Simplest library ever for getting json from http requests}

  s.rubyforge_project = "restfolia"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "multi_json", "~> 1.3.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "webmock"
end
