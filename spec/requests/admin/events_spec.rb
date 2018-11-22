require "rails_helper"

RSpec.describe "Admin Action Page Analytics", type: :request do
  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    login admin

    @action_page = FactoryGirl.create(:action_page_with_views)
  end

  describe "#index" do
    it "responds with views over time as JSON" do
      get "/admin/action_pages/#{@action_page.slug}/events",
        { type: "views" },
        { "ACCEPT" => "application/json" }
      expect(response.code).to eq "200"
      expect(JSON.parse(response.body).keys.count).to eq(10)
    end

    it "filters by date" do
      start_date = (Time.now - 6.days).strftime("%Y-%m-%d")
      end_date = (Time.now - 2.days).strftime("%Y-%m-%d")
      get "/admin/action_pages/#{@action_page.slug}/events",
        { date_start: start_date, date_end: end_date, type: "views" },
        { "ACCEPT" => "application/json" }
      expect(JSON.parse(response.body).keys.count).to eq(4)
    end
  end

  describe "#views" do
    it "displays views in a table" do
      get "/admin/action_pages/#{@action_page.slug}/views"
      expect(response.code).to eq "200"
    end
  end
end
