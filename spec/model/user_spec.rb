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
end
