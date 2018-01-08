#encoding: utf-8

require_relative 'lib/hashstruct'

Gem::Specification.new do |s|
  s.name          = 'hashstruct'
  s.version       = HashStruct::VERSION
  s.summary       = 'Overly helpful magic hash structure.'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    HashStruct provides an object based on Hash, but acts like Struct (or OpenStruct), providing helpful
    accessors for each key from the get-go. It also magically parses string values when it can (eg, dates,
    URIs, numbers, and does so recursively.
  }
  s.license       = 'MIT'
  s.homepage      = 'http://github.com/jslabovitz/hashstruct'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rubygems-tasks', '~> 0.2'
end