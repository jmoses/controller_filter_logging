# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "controller_filter_logging/version"

Gem::Specification.new do |s|
  s.name        = "controller_filter_logging"
  s.version     = ControllerFilterLogging::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Moses"]
  s.email       = ["jon@burningbush.us"]
  s.homepage    = ""
  s.summary     = %q{Bring back controller filter logging to rails 3}
  s.description = %q{Gem to log execution and results of before_filter's for Rails 3}

  s.rubyforge_project = "controller_filter_logging"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
