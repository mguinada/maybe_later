require './lib/boot.rb'

BootSequence.new(environment: 'test').execute

require 'capybara'
require 'capybara/dsl'

module SessionHelper
  def sign_in(user = nil)
    user = User.create!(email: 'test.user@example.com', password: 'test_password') if user.nil?
    link = Link.create!(url: 'test.example.org')

    Reference.create!(user: user, link: link, title: 'Test title', description: 'Test description')

    visit '/signin'

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'sign-in-button'
  end

  def sign_out
    visit '/session/destroy'
  end
end

RSpec.configure do |config|
  #Tell capybara of our application
  Capybara.app = Application

  #Capybara.default_driver = :selenium
  #Capybara.javascript_driver = :selenium
  #Capybara.default_wait_time = 5

  config.include(SessionHelper)

  config.before(:each) do
    [Link, Reference, User].each do |m|
      m.send :delete_all
    end
  end

  config.include Capybara::DSL
end