require "rails_helper"

RSpec.describe "Admin Users", type: :request do
  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    login admin
  end

  describe "#index" do
    before do
      10.times do |n|
        FactoryGirl.create(:user, created_at: Time.now - n.days)
      end
    end

    it "responds with users created over time as JSON" do
      get "/admin/users", params: {}, headers: { "ACCEPT" => "application/json" }
      expect(response.code).to eq "200"
      expect(JSON.parse(response.body).keys.count).to eq(10)
    end

    it "filters by date" do
      start_date = (Time.now - 6.days).strftime("%Y-%m-%d")
      end_date = (Time.now - 2.days).strftime("%Y-%m-%d")
      get "/admin/users",
        params: { date_start: start_date, date_end: end_date },
        headers: { "ACCEPT" => "application/json" }
      expect(JSON.parse(response.body).keys.count).to eq(4)
    end
  end
end
