require 'spec_helper'

describe "user saves link" do
  before(:each) do
    User.create!(email: 'user@example.com', password: 'test_password')

    visit '/signin'

    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'test_password'

    click_button 'sign-in-button'
  end

  after(:each) do
  	visit '/session/destroy'
  end

  it "by filling a form" do
  	visit '/me/link/new'

  	fill_in 'url', with: 'http://www.example.com'
  	fill_in 'title', with: 'Example Link'
  	fill_in 'description', with: 'Example description'

  	click_button 'new-link-button'

	  current_path.should eq('/me')

  	page.should have_content('http://www.example.com')
  	page.should have_content('Example Link')
  	page.should have_content('Example description')
  end  
end