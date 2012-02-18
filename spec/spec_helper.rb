require './lib/boot.rb'

BootSequence.new(environment: 'test').execute

require 'capybara'
require 'capybara/dsl'

#Can be :chrome, :firefox or :ie
#Selenium::WebDriver.for :chrome
#Capybara.default_driver = :selenium

RSpec.configure do |config|
  #Tell capybara of our application
  Capybara.app = Application

  config.before(:each) do
    [Link, Reference, User].each do |m|
      m.send :delete_all
    end
  end

  config.include Capybara::DSL
end