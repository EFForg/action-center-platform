require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  before { sign_in FactoryBot.create(:admin_user) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "redirects" do
      patch :update, params: { id: FactoryBot.create(:collaborator_user), user: { collaborator: "1" } }
      expect(response).to have_http_status(:found)
    end
  end
end
