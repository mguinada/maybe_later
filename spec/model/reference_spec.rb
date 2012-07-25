describe Reference do
  let!(:subject)   { Reference.new }
  let!(:link)      { Link.create!(url: 'test.example.org') }
  let!(:user)      { User.create!(email: 'user@example.com', password: 'test_password') }
  let!(:reference) { Reference.create!(user: user, link: link, title: 'test') }

  it "stores creation timestamp" do
    ref = Reference.new(user: user, link: link)

    ref.created_at.should be_blank
    ref.save.should be_true
    ref.created_at.should be_present
  end

  describe "::with_url" do
    it "finds references to a given url" do
      a_link = Link.create!(url: 'a-link.example.org')
      new_ref = Reference.create!(user: user, link: a_link, title: 'test')
      Reference.with_url(link.url).to_a.should eq([reference])
    end
  end
end