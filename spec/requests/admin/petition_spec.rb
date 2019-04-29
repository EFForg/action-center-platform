require "rails_helper"

RSpec.describe "Admin Action Pages", type: :request do
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
