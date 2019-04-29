require "rails_helper"

RSpec.describe SubscriptionsController, type: :controller do
  before do
    stub_civicrm
  end

  describe "#create" do
    let(:valid_attributes) do
      {
        subscription: {
          "email" => "johnsmith@eff.org",
          "mailing_list" => "effector"
        },
        format: :json
      }
    end

    it "can accept an email" do
      post :create, params: valid_attributes

      expect(response.code).to eq "200"
    end

    it "can reject a spammy looking email" do
      invalid_email = valid_attributes.merge(subscription: { email: "meh" })
      post :create, params: invalid_email

      expect(response.code).to eq "400"
    end
  end

  describe "#edit" do
    let(:subscription) { FactoryGirl.create(:subscription) }
    subject { get :edit, params: { id: subscription } }

    it "redirects to supporters" do
      sign_in FactoryGirl.create(:user)
      expect(subject).to redirect_to(/#{Rails.application.secrets.supporters["host"]}/)
    end

    describe "without a successful connection to civicrm" do
      before do
        stub_request(:post, CiviCRM::supporters_api_url).
          and_return(status: 400, body: "{}", headers: {})
      end

      it "fails gracefully" do
        sign_in FactoryGirl.create(:user)
        expect(subject).to redirect_to("/account")
        expect(flash[:error]).to be_present
      end
    end
  end

end
