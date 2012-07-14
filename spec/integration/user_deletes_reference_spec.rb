require 'spec_helper'

describe 'User deletes a reference' do
  before(:each) do
    sign_in
  end

  after(:each) do
    sign_out
  end

  it "upon confirmation" do
    visit '/me'

    click_link 'delete-button'

    page.should have_content('Are You Sure?')

    click_link 'Yes'

    #save_and_open_page

    page.should_not have_content('Test title')
    page.should have_content('Link deleted')
  end
end
