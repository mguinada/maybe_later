require 'spec_helper'

describe "Welcome page" do
  it "describes the service" do
    visit "/"
    page.should have_content("Maybe Later is a ...")
  end
end