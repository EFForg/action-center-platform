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
end
