require 'spec_helper'

describe "User saves link" do
  before(:each) do
    sign_in
  end

  after(:each) do
  	sign_out
  end

  it "by filling a form" do
  	visit '/me/new_link'

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