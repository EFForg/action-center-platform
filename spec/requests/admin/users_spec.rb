require "rails_helper"

RSpec.describe "Admin Users", type: :request do
  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    login admin
  end

  describe "#index" do
    before do
      10.times do |n|
        FactoryGirl.create(:user, created_at: Time.now - n.days, email: "user-#{n}@example.com")
      end
    end

    it "responds with a list of users" do
      get "/admin/users"
      expect(response.code).to eq "200"

      User.all.each { |user| expect(response.body).to include(user.email) }
    end

    it "filters by email" do
      get "/admin/users", params: { query: "user-3@example.com" }

      expect(response.body).to include("user-3@example.com")

      User.where.not(email: "user-3@example.com").each do |user|
        expect(response.body).not_to include(user.email)
      end
    end
  end
end
