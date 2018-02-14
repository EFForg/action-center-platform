require "rails_helper"

RSpec.describe "Admin Action Pages", type: :request do
  let(:valid_attributes) do
    {
      action_page: {
        title: "Save Kittens",
        summary: "Save kittens in great detail",
        description: "Some description",
        email_text: "",
        enable_tweet: "0"
      },
      add_targets: ""
    }
  end

  describe "admins" do
    before(:each) do
      @admin = FactoryGirl.create(:admin_user)
      login @admin
    end

    it "should let admins download the CSV" do
      @petition = FactoryGirl.create(:petition_complete_with_one_hundred_signatures)

      get "/admin/petitions/#{@petition.id}/presentable_csv"

      expect(assigns(:petition).signatures.count).to eq 100
    end
  end
end
