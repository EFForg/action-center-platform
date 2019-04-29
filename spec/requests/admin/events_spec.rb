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
            and_return(Time.local(2019)).
            at_least(:once)

      get "/admin/action_pages/#{@action_page.slug}/events",
        { type: "views" },
        { "ACCEPT" => "application/json" }

      expect(response.code).to eq "200"

      # Default is to return data for the previous month.
      expect(JSON.parse(response.body).keys).
        to include(*(1..31).map { |i| sprintf("Dec %d", i) })
    end

    it "filters by date" do
      start_date = Time.utc(2019, 1, 1).strftime("%Y-%m-%d")
      end_date = Time.utc(2019, 1, 7).strftime("%Y-%m-%d")
      get "/admin/action_pages/#{@action_page.slug}/events",
        { date_start: start_date, date_end: end_date, type: "views" },
        { "ACCEPT" => "application/json" }

      # Returns one datapoint per day in range.
      expect(JSON.parse(response.body).keys).
        to eq([
                "Jan 1",
                "Jan 2",
                "Jan 3",
                "Jan 4",
                "Jan 5",
                "Jan 6",
                "Jan 7",
                "Jan 8"
              ])
    end
  end

  describe "#views" do
    it "displays views in a table" do
      get "/admin/action_pages/#{@action_page.slug}/views"
      expect(response.code).to eq "200"
    end
  end
end
