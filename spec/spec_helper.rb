require './lib/boot.rb'

BootSequence.new(environment: 'test').execute

require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  #Tell capybara of our application
  Capybara.app = Application

  config.before(:each) do
    User.delete_all
  end

  config.include Capybara::DSL
end