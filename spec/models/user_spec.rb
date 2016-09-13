require "rails_helper"

describe User do

  let(:attr) { FactoryGirl.attributes_for :user }
  let(:user) { FactoryGirl.create(:user) }

  it "creates a new instance given a valid attributes" do
    User.create!(attr)
  end

  describe "password management" do
    it "resets password reset tokens upon email change" do
      user.update_attributes(reset_password_token: "stub_token")
      user.update_attributes(email: "2" + user.email)
      user.confirm
      expect(user.reset_password_token).to be_nil
    end

    it "allows new users to use weak passwords" do
      result = set_weak_password(user)
      expect(result).to be_truthy
    end

    it "makes sure admins are using strong passwords" do
      user = FactoryGirl.create(:user, admin: true)

      result = set_weak_password(user)
      expect(result).to be_falsey

      result = set_strong_password(user)
      expect(result).to be_truthy
    end
  end

  describe "track user actions" do
    let(:ahoy) { Ahoy::Tracker.new }
    let(:action_page) { FactoryGirl.create :action_page_with_petition }

    it "ranks users" do
      record_several_actions
      expect(user.percentile_rank).to eq(50)
    end
  end
end


def record_several_actions
  FactoryGirl.create(:user)
  ahoy.authenticate(FactoryGirl.create(:user))
  3.times { track_signature(action_page) }

  ahoy.authenticate(FactoryGirl.create(:user))
  1.times { track_signature(action_page) }

  ahoy.authenticate(user)
  2.times { track_signature(action_page) }
  track_view(action_page)
end

def track_signature(action_page)
  ahoy.track "Action",
    { type: "action", actionType: "signature", actionPageId: action_page.id },
    action_page: action_page
end

def track_view(action_page)
  ahoy.track "View",
    { type: "action", actionType: "view", actionPageId: action_page.id },
    action_page: action_page
end
