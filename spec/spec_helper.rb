require 'simplecov'
SimpleCov.start do
  enable_coverage :branch if ENV['BRANCH_COVERAGE']
end

require 'rubygems'
require 'bundler'
Bundler.require :default, :development
