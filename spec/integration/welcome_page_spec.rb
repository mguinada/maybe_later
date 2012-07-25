describe "Welcome page" do
  it "describes the service" do
    visit "/"
    page.should have_content("Maybe Later is")
  end

  it "points to the sign in from" do
    visit "/"
    page.should have_link("Sign in")
  end
end
