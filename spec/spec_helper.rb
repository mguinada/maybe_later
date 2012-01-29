require 'rubygems'
require 'sinatra'
require 'rspec'

$:.unshift File.expand_path(File.dirname(__FILE__)) + "/../lib"

set :environment, :test
disable :run
require 'app'

require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  #Tell capybara of our application
  Capybara.app = Application

  config.include Capybara::DSL
end