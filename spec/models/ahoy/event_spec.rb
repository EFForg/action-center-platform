require "rails_helper"

describe Ahoy::Event do
  describe "#types" do
    it "returns event types for an action" do
      action_page = FactoryGirl.create(:action_page_with_tweet)
      expect(Ahoy::Event.action_types(action_page)).to eq([:views, :tweets])
    end
  end

  describe "calculations" do
    let!(:now) { Time.zone.parse("12-11-2019 11:00 AM") }
    let!(:page) do
      FactoryGirl.create(:action_page_with_petition,
                         created_at: now - 1.week, updated_at: now)
    end
    before(:each) do
      FactoryGirl.create_list(:ahoy_view, 3,
                              action_page: page, time: now - 3.days)
      FactoryGirl.create_list(:ahoy_view, 2,
                              action_page: page, time: now + 1.hour)
      FactoryGirl.create(:ahoy_signature, action_page: page, time: now + 2.hours)
      FactoryGirl.create(:ahoy_signature, action_page: page, time: now - 2.days)
      page.reload
    end

    describe ".counts_by_date" do
      it "returns a hash with :counts of views and actions by date" do
        result = page.events.table_data
        target_date = now.strftime("%b %-e %Y")
        expect(result[target_date]).to eq({ view: 2, action: 1 })
      end
    end

    describe ".summary" do
      it "returns a hash with :summary of total views and actions" do
        result = page.events.summary
        expect(result).to eq({ view: 5, action: 2 })
      end
    end
  end
end
