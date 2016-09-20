require "rails_helper"

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
      @user.confirm
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

  describe "GET #show" do
    let(:ahoy) {
      ahoy = Ahoy::Tracker.new
    }

    before(:each) do
      @user = User.create!(@attr)
    end

    it "ranks users" do
      # Users take several actions
      track_views_and_actions

      result = @user.percentile_rank
      expect(result).to be(50)
    end
  end
end


def track_views_and_actions
  FactoryGirl.create(:user)
  ahoy.authenticate(FactoryGirl.create(:user))
  3.times { track_signature }

  ahoy.authenticate(FactoryGirl.create(:user))
  1.times { track_signature }

  ahoy.authenticate(@user)
  2.times { track_signature }
  track_view
end

def track_signature
  @actionPage = FactoryGirl.create(:action_page_with_petition)
  ahoy.track "Action",
    { type: "action", actionType: "signature", actionPageId: @actionPage.id },
    action_page: @actionPage
end

def track_view
  @actionPage = FactoryGirl.create(:action_page_with_petition)
  ahoy.track "View",
    { type: "action", actionType: "view", actionPageId: @actionPage.id },
    action_page: @actionPage
end
