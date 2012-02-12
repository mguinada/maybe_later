require 'spec_helper'

describe Link do
  before(:each) { Link.create!(url: 'http://example.com', title: 'example') }

  it "is associated to users" do
    Link.new.respond_to?(:users).should be_true
    Link.new.respond_to?(:users=).should be_true
  end

  it "validates URL uniqueness" do    
    link = Link.new(url: 'http://example.com', title: 'example')
    link.should_not be_valid
    
    link.errors[:url].should eq(["is already taken"])
  end

  it "validates the URL" do
    pending
  end

  it "it harmonizes URL format" do
    pending
  end
end