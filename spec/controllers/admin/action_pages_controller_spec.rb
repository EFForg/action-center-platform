require "rails_helper"

RSpec.describe Admin::ActionPagesController, type: :controller do
  include Devise::TestHelpers

  let(:petition_action_page){ FactoryGirl.create(:action_page_with_petition) }

  describe "GET #index" do
    render_views

    context "user is an admin" do
      before{ login_as_admin }

      it "should have tabs and panels for create/browse actions, homepage, analytics, partners, topics, and users" do
        get :index

        expect(response).to have_http_status(:success)

        doc = Nokogiri::HTML(response.body)
        expect(doc.at_css(".create-new a")).to be_present
        expect(doc.at_css("a[data-tab=action-pages]")).to be_present
        expect(doc.at_css(".tab-pane#action-pages")).to be_present
        expect(doc.at_css("a[data-tab=homepage-settings]")).to be_present
        expect(doc.at_css(".tab-pane#homepage-settings")).to be_present
        expect(doc.at_css("a[data-tab=analytics]")).to be_present
        expect(doc.at_css(".tab-pane#analytics")).to be_present
        expect(doc.at_css("a[data-tab=partners]")).to be_present # no pane for partners, links to from separate controller
        expect(doc.at_css("a[data-tab=topics]")).to be_present
        expect(doc.at_css(".tab-pane#topics")).to be_present
        expect(doc.at_css("a[data-tab=users]")).to be_present # no pane for users, links to from separate controller
      end
    end

    context "user is a collaborator" do
      before{ login_as_collaborator }

      it "should have tabs and panels for actions and analytics, and nothing else" do
        get :index

        expect(response).to have_http_status(:success)

        doc = Nokogiri::HTML(response.body)
        expect(doc.at_css("a[data-tab=action-pages]")).to be_present
        expect(doc.at_css(".tab-pane#action-pages")).to be_present
        expect(doc.at_css("a[data-tab=analytics]")).to be_present
        expect(doc.at_css(".tab-pane#analytics")).to be_present

        expect(doc.at_css(".create-new a")).not_to be_present
        expect(doc.at_css("a[data-tab=homepage-settings]")).not_to be_present
        expect(doc.at_css(".tab-pane#homepage-settings")).not_to be_present
        expect(doc.at_css("a[data-tab=partners]")).not_to be_present
        expect(doc.at_css("a[data-tab=topics]")).not_to be_present
        expect(doc.at_css(".tab-pane#topics")).not_to be_present
        expect(doc.at_css("a[data-tab=users]")).not_to be_present
      end
    end
  end

  describe "GET #updated_at" do
    before{ login_as_admin }

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
