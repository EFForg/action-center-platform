require "rails_helper"

RSpec.describe "Admin Action Pages", type: :request do
  describe "admins" do
    before(:each) do
      @admin = FactoryBot.create(:admin_user)
      sign_in @admin
    end

    it "should let admins download the CSV" do
      @petition = FactoryBot.create(:petition_complete_with_one_hundred_signatures)

      get "/admin/petitions/#{@petition.id}/presentable_csv"

      expect(assigns(:petition).signatures.count).to eq 100
    end
  end
end
