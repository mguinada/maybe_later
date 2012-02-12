require 'spec_helper'

describe Link do
  before(:each) { Link.create!(url: "http://example.com", title: 'example') }

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
    link = Link.new(url: 'invalid url', title: 'example')
    link.should_not be_valid    
    link.errors[:url].should eq(["is invalid"])

    link = Link.new(url: 'example.org', title: 'example')
    link.should be_valid

    link = Link.new(url: 'www.example.org', title: 'example')
    link.should be_valid
    
    link = Link.new(url: 'http://www.example.org', title: 'example')
    link.should be_valid

    link = Link.new(url: 'https://www.example.org', title: 'example')
    link.should be_valid
  end

  it "it harmonizes URL format" do
    link = Link.new(url: 'http://example.com')
    link.url.should eq('http://example.com')

    link = Link.new(url: 'example.com')
    link.url.should eq('http://example.com')

    link = Link.new(url: 'www.example.com')
    link.url.should eq('http://www.example.com')

    link = Link.new(url: 'https://www.example.com')
    link.url.should eq('https://www.example.com')
  end
end