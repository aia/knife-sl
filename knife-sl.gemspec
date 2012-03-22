# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-sl/version"

Gem::Specification.new do |s|
  s.name        = "knife-sl"
  s.version     = Knife::Sl::VERSION
  s.has_rdoc = true
  s.authors     = ["Artem Veremey"]
  s.email       = ["artem@veremey.net"]
  s.homepage = "http://wiki.opscode.com/display/chef"
  s.summary = "SoftLayer Support for Chef's Knife Command"
  s.description = s.summary
  s.extra_rdoc_files = ["README.rdoc", "LICENSE" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency "softlayer_api"
  s.require_paths = ["lib"]
end
