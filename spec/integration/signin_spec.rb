require 'spec_helper'

describe "Sign in" do
  before(:each) do
    User.create!(email: 'user@example.com', password: 'test_password')
  end

  it "asks user for an email and password" do
    visit '/signin'

    page.should have_field('email')
    page.should have_field('password')
    page.should have_button('sign-in-button')
  end

  it "starts a session given valid credentials" do
    visit '/signin'

    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'test_password'

    click_button 'sign-in-button'

    page.should have_content('You successfully signed in.')
    page.should have_link('Sign out')
  end

  it "denies session start given invalid credentials" do
    visit '/signin'

    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'no_such_password'

    click_button 'sign-in-button'

    page.should have_content('The given credentials are not valid.')
    page.should_not have_link('Sign out')
  end

  it "intercepts requests to private resources" do
    visit '/private'

    current_path.should eq('/signin')
    page.should have_content('You must signin!')
  end

  it "redirects back to original request" do
    visit '/private' #TODO: Make authentication a helper

    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'test_password'

    click_button 'sign-in-button'

    current_path.should eq('/private')
  end
end