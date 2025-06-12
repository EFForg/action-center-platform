require "rails_helper"

describe User do
  let(:attr) { FactoryBot.attributes_for :user }
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    stub_civicrm
  end

  it "creates a new instance given a valid attributes" do
    User.create!(attr)
  end

  describe "password management" do
    it "resets password reset tokens upon email change" do
      user.update(reset_password_token: "stub_token")
      user.update(email: "2#{user.email}")
      user.confirm
      expect(user.reset_password_token).to be_nil
    end

    it "resets password reset tokens upon password change" do
      user.update(reset_password_token: "stub_token")
      expect(user.reset_password_token).not_to be_nil
      user.update(password: "My new password is pretty great")
      expect(user.reset_password_token).to be_nil
    end

    it "allows new users to use weak passwords" do
      result = set_weak_password(user)
      expect(result).to be_truthy
    end

    it "makes sure admins are using strong passwords" do
      user = FactoryBot.create(:user, admin: true)

      result = set_weak_password(user)
      expect(result).to be_falsey

      result = set_strong_password(user)
      expect(result).to be_truthy
    end
  end

  describe "track user actions" do
    let(:user) { FactoryBot.create(:user, record_activity: true) }
    let(:action_page) { FactoryBot.create :action_page_with_petition }

    it "knows if the user has taken a given action" do
      FactoryBot.create(:ahoy_signature, action_page: action_page, user: user)
      expect(user.taken_action?(action_page)).to be_truthy
    end
  end

  describe ".manage_subscription_url!" do
    it "encodes a checksum" do
      allow(Civicrm).to receive(:get_checksum).and_return("xyz")
      expect(user.manage_subscription_url!).to include("cs=xyz")
    end
  end
end

# TODO: possibly remove, this seems unused?
def record_several_actions
  create_user_with_tracked_actions(signatures: 0, views: 0)
  create_user_with_tracked_actions(signatures: 3, views: 0)
  create_user_with_tracked_actions(signatures: 1, views: 0)
  create_user_with_tracked_actions(signatures: 2, views: 1)
end

def user_with_tracked_actions(signatures: 1, views: 1)
  user = FactoryBot.create(:user, record_activity: true)
  signatures.times do
    action = FactoryBot.create(:action_page_with_petition)
    FactoryBot.create(:ahoy_signature, action_page: action, user: user)
  end
  views.times do
    action = FactoryBot.create(:action_page_with_email)
    FactoryBot.create(:ahoy_view, action_page: action, user: user)
  end
end
