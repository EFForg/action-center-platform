require "rails_helper"

RSpec.describe Admin::ActionPagesController, type: :controller do
  include Devise::TestHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin_user)
  end

  let(:petition_action_page){ FactoryGirl.create(:action_page_with_petition) }

  describe "GET #updated_at" do
    def tparam(time)
      time.strftime("%Y/%m/%d %H:%M:%S.%9N %Z %z")
    end

    it ".updated field should be false if params[:updated_at] is gte action_page.updated_at" do
      get :updated_at, { action_page_id: petition_action_page.to_param,
                         updated_at: tparam(petition_action_page.updated_at) }

      expect(response.content_type).to eq("application/json")
      expect(JSON.parse(response.body)["updated"]).to eq(false)

      get :updated_at, { action_page_id: petition_action_page.to_param,
                         updated_at: tparam(petition_action_page.updated_at + 2) }

      expect(response.content_type).to eq("application/json")
      expect(JSON.parse(response.body)["updated"]).to eq(false)
    end

    it ".updated field should be true if params[:updated_at] is lt action_page.updated_at" do
      get :updated_at, { action_page_id: petition_action_page.to_param,
                         updated_at: tparam(petition_action_page.updated_at - 0.1) }

      expect(response.content_type).to eq("application/json")
      expect(JSON.parse(response.body)["updated"]).to eq(true)
    end
  end
end
