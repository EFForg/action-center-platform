require "rails_helper"

RSpec.describe "Admin Topics", type: :request do
  before do
    sign_in FactoryBot.create(:admin_user)
  end

  describe "#index" do
    it "renders the React on Rails topic category table mount" do
      topic_category = FactoryBot.create(:topic_category, name: "Privacy")

      get "/admin/topics"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("TopicCategoryTables")
      expect(response.body).to include("Privacy")
      expect(response.body).to include("admin_topics")
      expect(response.body).not_to include("data-react-class")
      expect(response.body).to include(topic_category.id.to_s)
    end
  end
end
