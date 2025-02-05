lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lightly/version'

Gem::Specification.new do |s|
  s.name        = 'lightly'
  s.version     = Lightly::VERSION
  s.summary     = 'File cache for performing heavy tasks, lightly.'
  s.description = 'Easy to use file cache'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/lightly'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.1'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/lightly/issues',
    'source_code_uri'       => 'https://github.com/DannyBen/lightly',
    'rubygems_mfa_required' => 'true',
  }
end
