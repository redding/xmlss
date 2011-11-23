# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "xmlss/version"

Gem::Specification.new do |s|
  s.name        = "xmlss"
  s.version     = Xmlss::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kelly Redding"]
  s.email       = ["kelly@kelredd.com"]
  s.homepage    = "http://github.com/kelredd/xmlss"
  s.summary     = %q{Generate spreadsheet docs for MS Excel using XML Spreedsheet}
  s.description = %q{This gem provides an api for constructing spreadsheet data and then uses that data to generate xml that can be interpreted by MS Excel.  The xml conforms to the XML Spreadsheet spec (http://msdn.microsoft.com/en-us/library/aa140066(office.10).aspx).}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("bundler", ["~> 1.0"])
  s.add_development_dependency("assert", ["~> 0.6"])
  s.add_dependency("nokogiri", ["~> 1.5.0"])
  s.add_dependency("enumeration", ["~> 1.2"])
end
