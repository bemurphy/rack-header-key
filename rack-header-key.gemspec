# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/header_key/version"

Gem::Specification.new do |s|
  s.name        = "rack-header-key"
  s.version     = Rack::HeaderKey::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brendon Murphy"]
  s.email       = ["xternal1+github@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Rack Middleware for authenticating requests via an http header}
  s.description = s.summary

  s.rubyforge_project = "rack-header-key"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rack'
  s.add_development_dependency 'rspec'
end
