require './lib/boot.rb'

BootSequence.new(environment: 'test').execute

require 'capybara'
require 'capybara/dsl'

module SessionHelper
  def sign_in
    user = User.create!(email: 'test.user@example.com', password: 'test_password')
    link = Link.create!(url: 'test.example.org')

    Reference.create!(user: user, link: link, title: 'Test title', description: 'Test description')

    visit '/signin'

    fill_in 'email', with: 'test.user@example.com'
    fill_in 'password', with: 'test_password'

    click_button 'sign-in-button'
  end

  def sign_out
    visit '/session/destroy'
  end
end

RSpec.configure do |config|
  #Tell capybara of our application
  Capybara.app = Application

  Capybara.register_driver :selenium do |app|
    #Tell selenium driver to resynchronize. This is required with selenium 2.x for ajax testing
    Capybara::Selenium::Driver.new(app, browser: :firefox, resynchronize: true)
  end

  Capybara.default_driver = :selenium
  #Capybara.default_wait_time = 5

  config.include(SessionHelper)

  config.before(:each) do
    [Link, Reference, User].each do |m|
      m.send :delete_all
    end
  end

  config.include Capybara::DSL
end