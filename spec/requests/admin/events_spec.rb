require "rails_helper"

RSpec.describe "Admin Action Page Analytics", type: :request do
  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    login admin

    @action_page = FactoryGirl.create(:action_page_with_views)
  end

  describe "#index" do
    it "responds with views over time as JSON" do
      expect(Time.zone).
        to receive(:now).
            and_return(Time.utc(2019)).
            at_least(:once)

      get "/admin/action_pages/#{@action_page.slug}/events",
        { type: "views" },
        { "ACCEPT" => "application/json" }

      expect(response.code).to eq "200"

      # Default is to return data for the previous month.
      expect(JSON.parse(response.body).keys).
        to include(*(1..31).map{ |i| sprintf("2018-12-%02d", i) })
    end

    it "filters by date" do
      start_date = Time.utc(2019, 1, 1).strftime("%Y-%m-%d")
      end_date = Time.utc(2019, 1, 5).strftime("%Y-%m-%d")
      get "/admin/action_pages/#{@action_page.slug}/events",
        { date_start: start_date, date_end: end_date, type: "views" },
        { "ACCEPT" => "application/json" }

      # Returns one datapoint per day in range.
      expect(JSON.parse(response.body).keys).
        to eq(["2019-01-01", "2019-01-02", "2019-01-03", "2019-01-04", "2019-01-05"])
    end
  end

  describe "#views" do
    it "displays views in a table" do
      get "/admin/action_pages/#{@action_page.slug}/views"
      expect(response.code).to eq "200"
    end
  end
end
