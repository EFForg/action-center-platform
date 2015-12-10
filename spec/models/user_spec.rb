require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      email: "me@example.com",
      password: "password",
      password_confirmation: "password",
      first_name: "John",
      last_name: "Doe"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  describe "Created users" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "User's reset tokens should be cleared upon email change" do
      @user.update_attributes(reset_password_token: "stub_token")
      @user.update_attributes(email: "2" + @user.email)
      @user.confirm!
      expect(@user.reset_password_token).to be_nil
    end

  end

end
