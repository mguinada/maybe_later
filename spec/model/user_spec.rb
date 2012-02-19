require 'spec_helper'

describe User do
  subject { User.new }
  let!(:user) { User.create!(email: 'user@example.com', password: 'test_password') }

  it "requires a valid email" do
    subject.should be_invalid
    subject.errors[:email].should eq(["is invalid", "can't be blank"])
  end

  it "requires a valid password" do
    subject.should be_invalid
    subject.errors[:password].should eq(["can't be blank", "is too short (minimum is 6 characters)"])
  end

  it "password is encoded" do
    subject.email = 'new_user@example.com'
    subject.password = 'a_password'
    subject.save
    subject.password_hash.should_not be_empty
  end

  it "is authenticatable" do
    User.authenticate('user@example.com', 'no_such_password').should be_nil
    User.authenticate('no_such_user@example.com', 'password').should be_nil
    User.authenticate('user@example.com', 'test_password').should eq(user)
  end

  describe "::create_reference" do
    before(:each) do
      Link.create!(url: "test.example.com", title: "Test URL")
    end

    it "creates new link if it doesn't exist already" do
      url = "a-new-link.example.org/q='test'"
      Link.all.size.should be(1)
      user.create_reference({url: url}).should be_persisted
      Link.all.size.should be(2)
    end

    it "associates to existing link if one is found" do
      url = "test.example.com"
      Link.all.size.should be(1)
      user.create_reference({url: url}).should be_persisted
      Link.all.size.should be(1)
    end

    it "preventes double referencing" do
      url = "test.example.com"
      user.create_reference({url: url}).should be_persisted

      lambda { user.create_reference({url: url}) }.should raise_error(DuplicateReference)
    end
  end
end