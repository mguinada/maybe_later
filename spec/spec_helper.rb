require './lib/boot.rb'

BootSequence.new(environment: 'test').execute

require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  #Tell capybara of our application
  Capybara.app = Application

  config.before(:each) do
    [Link, User].each do |m|
      m.send :delete_all
    end
  end

  config.include Capybara::DSL
end