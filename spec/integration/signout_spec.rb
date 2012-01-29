require 'spec_helper'

describe "Sign out" do
  before(:each) do
    User.create!(email: 'user@example.com', password: 'test_password')
  end

  it "terminates user session" do
    #TODO:Create test helper for sign in
    visit '/signin'

    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'test_password'

    click_button 'sign-in-button'

    page.should have_link('Sign out')
    click_link('Sign out')

    page.should have_content('You successfully signed out.')
  end
end