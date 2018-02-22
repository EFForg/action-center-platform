require "rails_helper"

RSpec.describe "Action Pages", type: :request do
  describe "small petition" do
    before(:each) do
      @action_page = FactoryGirl.create(:petition_with_99_signatures_needing_1_more).action_page
    end

    it "lists action pages" do
      get "/action"

      expect(response).to render_template(:index)
      expect(response.body).to include(@action_page.title)
    end

    it "should allow cors wildcard for broad web consumption" do
      get "/action"

      cors_wildcard_presence = response.headers.any? do |k, v|
        k == "Access-Control-Allow-Origin" && v == "*"
      end
      expect(cors_wildcard_presence).to be_truthy
    end
  end

  describe "large petition" do
    it "should present the count of signatures" do
      @action_page = FactoryGirl.create(:petition_complete_with_one_thousand_signatures).action_page

      path = "#{action_page_path(@action_page)}/signature_count"
      get path

      expect(response.body).to eq "1000"
    end
  end
end
