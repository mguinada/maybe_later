describe "User home" do
  before(:each) do
    sign_in
  end

  after(:each) do
    sign_out
  end

  it "lists links" do
    visit '/me'

    page.should have_content('http://test.example.org')
    page.should have_content('Test title')
    page.should have_content('Test description')
  end


  it "marking a link as read" do
    visit '/me'

    page.should have_link('Mark read')
  end

  it "allows link deletion" do
    visit '/me'

    page.should have_link('delete-button')
  end
end