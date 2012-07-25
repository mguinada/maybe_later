describe "Site user" do
  before(:each) do
    sign_in
  end

  after(:each) do
    sign_out
  end

  it "saves link" do
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

  it "lists links" do
    visit '/me'

    page.should have_content('http://test.example.org')
    page.should have_content('Test title')
    page.should have_content('Test description')
  end

  it "marks a link as read" do
    visit '/me'
    pending 'to be implemented'
    #page.should have_link('Mark read')
  end

  it "deletes link" do
    visit '/me'

    click_link 'delete-button'

    page.should have_content('Are You Sure?')

    click_link 'Yes'

    page.should_not have_content('Test title')
    page.should have_content('Link deleted')
  end
end