lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
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
end
