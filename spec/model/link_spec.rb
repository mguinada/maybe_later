describe Link do
  before(:each) { Link.create!(url: "http://example.com") }

  it "validates URL uniqueness" do
    link = Link.new(url: 'http://example.com')
    link.should_not be_valid

    link.errors[:url].should eq(["is already taken"])
  end

  it "validates the URL" do
    link = Link.new(url: 'invalid url')
    link.should_not be_valid
    link.errors[:url].should eq(["is invalid"])

    link = Link.new(url: 'example.org')
    link.should be_valid

    link = Link.new(url: 'www.example.org')
    link.should be_valid

    link = Link.new(url: 'http://www.example.org')
    link.should be_valid

    link = Link.new(url: 'https://www.example.org')
    link.should be_valid
  end

  it "harmonizes URL format" do
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