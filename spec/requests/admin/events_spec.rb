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
          to include(*(1..31).map { |i| sprintf("Dec %d 2018", i) })
      end

      it "filters by date" do
        start_date = Time.utc(2019, 1, 1).strftime("%Y-%m-%d")
        end_date = Time.utc(2019, 1, 7).strftime("%Y-%m-%d")
        get "/admin/action_pages/#{action_page.slug}/events",
          params: {
            date_range_text: "Jan 1, 2019 - Jan 8, 2019",
            type: "views"
          },
          headers: { "ACCEPT" => "application/json" }

        # Returns one datapoint per day in range.
        expect(JSON.parse(response.body).keys).
          to eq([
                  "Jan 1 2019",
                  "Jan 2 2019",
                  "Jan 3 2019",
                  "Jan 4 2019",
                  "Jan 5 2019",
                  "Jan 6 2019",
                  "Jan 7 2019",
                  "Jan 8 2019"
                ])
      end
    end

    context "without type param" do
      before do
        allow(Time.zone).to receive(:now).and_return(Time.local(2019))
        action_page.update(
          enable_petition: true,
          petition_id: Petition.create.id
        )

        FactoryGirl.create(:ahoy_signature,
                           action_page: action_page,
                           time: Time.zone.now)
      end

      it "renders html" do
        get "/admin/action_pages/#{action_page.slug}/events"
        expect(response.code).to eq "200"
      end
    end
  end

end
