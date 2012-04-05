gemfile = File.expand_path('../../Gemfile', __FILE__)
if File.exist?(gemfile)
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
end

require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
  add_filter "/.bundle/"
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
