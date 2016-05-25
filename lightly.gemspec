lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lightly/version'

Gem::Specification.new do |s|
  s.name        = 'lightly'
  s.version     = Lightly::VERSION
  s.date        = Date.today.to_s
  s.summary     = "File cache for performing heavy tasks, lightly."
  s.description = "Easy to use file cache"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/lightly'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.0.0"

  s.add_development_dependency 'runfile', '~> 0.7'
  s.add_development_dependency 'runfile-tasks', '~> 0.4'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'simplecov', '~> 0.11'
  s.add_development_dependency 'byebug', '~> 9.0'
end
