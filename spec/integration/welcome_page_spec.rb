require 'spec_helper'

describe "Welcome page" do
  it "describes the service" do
    visit "/"
    page.should have_content("Maybe Later is a ...")
  end

  it "points to the login from" do
    visit "/"
    page.should have_link("Sign in")
  end
end
