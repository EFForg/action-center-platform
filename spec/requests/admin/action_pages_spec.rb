require 'rails_helper'

RSpec.describe "Admin Action Pages", type: :request do

  let(:valid_attributes) { {
    action_page: {
      title: "Save Kittens",
      summary: "Save kittens in great detail",
      description: "Some description",
      email_text: "",
      enable_tweet: "0"},
    add_targets: ""
  } }

  describe "Non-Privileged Users" do

    it "should prevent them creating action pages" do
      expect {
        post "/admin/action_pages", valid_attributes
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end

  end

  describe "Admins" do

    before(:each) do
      @admin = FactoryGirl.create(:admin_user)
      login @admin
    end

    it "should allow them creating action pages with valid attributes" do
      post "/admin/action_pages", valid_attributes

      expect(response).to redirect_to(assigns(:actionPage))
      follow_redirect!

      expect(response.code).to eq "200"
      expect(ActionPage.count).to eq 1
    end

  end

end
