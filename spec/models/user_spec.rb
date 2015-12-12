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

    it "should reset password reset tokens upon email change" do
      @user.update_attributes(reset_password_token: "stub_token")
      @user.update_attributes(email: "2" + @user.email)
      @user.confirm!
      expect(@user.reset_password_token).to be_nil
    end

    it "should make sure admins are using strong passwords" do
      @user.admin = true
      @user.save

      result = set_weak_password(@user)
      expect(result).to be_falsey

      result = set_strong_password(@user)
      expect(result).to be_truthy
    end

    it "should allow new users to use weak passwords" do
      result = set_weak_password(@user)
      expect(result).to be_truthy
    end


  end

end
