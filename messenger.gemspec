# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'messenger/version_number'

Gem::Specification.new do |s|
  s.name        = "messenger"
  s.version     = Messenger::VersionNumber.new.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brandon Arbini", "Nathan Sutton", "Matthew McClure"]
  s.email       = "mmcclure@brightcove.com"
  s.homepage    = "http://github.com/zencoder/messenger"
  s.summary     = "Messenger: easy message sending"
  s.description = "Messenger: easy message sending for various protocols."
  s.executables = ["messenger"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.rubyforge_project = "messenger"
  s.add_dependency "scashin133-xmpp4r-simple"
  s.add_dependency "mail"
  s.add_dependency "httparty"
  s.add_dependency "trollop"
  s.add_dependency "addressable"
  s.add_development_dependency "test-unit", "~>3.0"
  s.add_development_dependency "shoulda",   "~>3.5"
  s.add_development_dependency "mocha",     "~>1.1"
  s.add_development_dependency "webmock",   "~>1.20"
  s.add_development_dependency "rake",      "~>10.4"
  s.add_development_dependency "rdoc",      "~>4.2"
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.markdown Rakefile)
  s.require_path = 'lib'
end
