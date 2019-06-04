require "rails_helper"

RSpec.describe "Admin Action Page Analytics", type: :request do
  let(:action_page) { FactoryGirl.create(:action_page_with_views) }
  before { login FactoryGirl.create(:admin_user) }

  describe "#index" do
    context "with type param" do
      it "responds with views over time as JSON" do
        expect(Time.zone).
          to receive(:now).
              and_return(Time.local(2019)).
              at_least(:once)

        get "/admin/action_pages/#{action_page.slug}/events",
          params: { type: "views" },
          headers: { "ACCEPT" => "application/json" }

        expect(response.code).to eq "200"

        # Default is to return data for the previous month.
        expect(JSON.parse(response.body).keys).
          to include(*(1..31).map { |i| sprintf("Dec %d", i) })
      end

      it "filters by date" do
        start_date = Time.utc(2019, 1, 1).strftime("%Y-%m-%d")
        end_date = Time.utc(2019, 1, 7).strftime("%Y-%m-%d")
        get "/admin/action_pages/#{action_page.slug}/events",
          params: { date_start: start_date, date_end: end_date, type: "views" },
          headers: { "ACCEPT" => "application/json" }

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

      it "responds to invalid type with 400" do
        get "/admin/action_pages/#{action_page.slug}/events",
          params: { type: "pasta" },
          headers: { "ACCEPT" => "application/json" }
        expect(response.code).to eq "400"
        expect(response.body).to be_empty
      end
    end

    context "without type param" do
      it "returns daily counts for all event types" do
        action_page.update_attribute(:enable_petition, true)
        get "/admin/action_pages/#{action_page.slug}/events",
          headers: { "ACCEPT" => "application/json" }

        expect(response.code).to eq "200"
        expect(JSON.parse(response.body).keys).
          to eq(["views", "signatures"])
        puts response
      end
    end
  end

end
