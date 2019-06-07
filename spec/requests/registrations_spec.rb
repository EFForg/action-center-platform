require "rails_helper"

RSpec.describe "Registrations", type: :request do
  before do
    stub_civicrm
  end

  describe "creates users" do
    let(:valid_attributes) do
      {
        user: {
          email: "buffy@sunnydale.edu",
          password: "mrpointy",
          password_confirmation: "mrpointy"
        }
      }
    end
    subject { post "/", params: valid_attributes }

    it "creates users" do
      subject
      expect(response.code).to eq "302"
      expect(User.count).to eq 1
      # Expect an email confirmation message.
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    it "lets unconfirmed users register a new password" do
      subject
      # Attempt to re-register+confirm with a new password,
      post "/", params: {
        user: {
          email: "buffy@sunnydale.edu",
          password: "hellmouth",
          password_confirmation: "hellmouth"
        }
      }
      expect(response.code).to eq "302"
      user = User.first
      user.confirm

      # User should now be able to log in with the new password.
      expect(user.valid_password?("hellmouth")).to be true
      # Expect two email confirmations, no password reset notice.
      expect(ActionMailer::Base.deliveries.count).to eq 2
    end
  end
end
