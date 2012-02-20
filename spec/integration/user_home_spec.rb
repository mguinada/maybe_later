describe "User home" do
  before(:each) do
    #TODO: Sign in test helper
    user = User.create!(email: 'user@example.com', password: 'test_password')
    link = Link.create!(url: 'test.example.org')    

    Reference.create!(user: user, link: link, title: 'Test title', description: 'Test description')

    visit '/signin'

    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'test_password'

    click_button 'sign-in-button'
  end

  it "lists links" do
    visit '/me'

    page.should have_content('http://test.example.org')
    page.should have_content('Test title')
    page.should have_content('Test description')
  end


  it "marking a link as read" do
    pending
    visit '/me'

    page.should have_link('mark as read')
  end

  it "allows link deletion" do
    visit '/me'

    page.should have_link('delete')
  end
end