require "rails_helper"

RSpec.describe ActionPageController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:action_page) { FactoryGirl.create :action_page }
  let(:admin) { login_as_admin }
  let(:collaborator) { login_as_collaborator }

  describe "GET #index" do
    render_views

    it "filters by category" do
      action_page
      category = FactoryGirl.create(:category, title: "Privacy")
      privacy_action_page = FactoryGirl.create(:action_page, category: category)
      get :index, params: { category: "Privacy" }
      expect(assigns(:actionPages)).to contain_exactly(privacy_action_page)
    end

    it "returns json" do
      action_page
      get :index, params: { format: "json" }
      expect(response.content_type).to eq("application/json")
      expect(response.body).to include(action_page.title)
    end
  end

  describe "GET #show" do
    it "redirects to a cannonical url" do
      original_slug = action_page.slug
      action_page.title = "Renamed Sample Action Page"
      action_page.save

      get :show, params: { id: original_slug }
      expect(response).to redirect_to action_page
    end

    it "doesn't redirect if the url is already cannonical" do
      get :show, params: { id: action_page.slug }
      expect(response.status).to eq(200)
    end

    it "redirects to an admin specified url if redirect is enabled" do
      action_page = FactoryGirl.create :action_page,
                      enable_redirect: true,
                      redirect_url: "https://example.com"
      get :show, params: { id: action_page }
      expect(response).to redirect_to "https://example.com"
    end

    context "archived" do
      let(:active_action_page) { FactoryGirl.create :action_page }
      let(:archived_action_page) {
        FactoryGirl.create :archived_action_page,
        active_action_page_for_redirect: active_action_page
      }

      it "redirects archived actions to active actions" do
        get :show, params: { id: archived_action_page }
        expect(response).to redirect_to active_action_page
      end

      it "doesn't redirect away from victories" do
        archived_action_page.update_attributes(victory: true)
        get :show, params: { id: archived_action_page }
        expect(response.status).to eq(200)
      end
    end

    context "unpublished" do
      let(:unpublished_action_page) { FactoryGirl.create :action_page, published: false }

      it "hides unpublished pages from unprivileged users" do
        expect {
          get :show, params: { id: unpublished_action_page }
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it "notifies admin users that a page is unpublished" do
        admin
        get :show, params: { id: unpublished_action_page }
        expect(flash[:notice]).to include("not published")
      end

      it "notifies collaborator users that a page is unpublished" do
        collaborator
        get :show, params: { id: unpublished_action_page }
        expect(flash[:notice]).to include("not published")
      end
    end
  end

  describe "GET #show_by_institution" do
    before(:each) do
      # Petition with two institutions
      @petition = FactoryGirl.create(:local_organizing_petition)
      @actionPage = @petition.action_page
      @actionPage.institutions << FactoryGirl.create(:institution)

      # Signature with affiliations to two different institutions
      signature = FactoryGirl.create(:signature,
        petition: @petition)
      signature.affiliations << FactoryGirl.create(:affiliation,
        institution: @actionPage.institutions.first)
      signature.affiliations << FactoryGirl.create(:affiliation,
        institution: @actionPage.institutions.last)

      # Signature with an affiliation to the second institutions
      signature = FactoryGirl.create(:signature,
        petition: @petition)
      signature.affiliations << FactoryGirl.create(:affiliation,
        institution: @actionPage.institutions.last,
        affiliation_type: @actionPage.affiliation_types.first)
    end

    context "html" do
      it "assigns signatures filtered by institution" do
        get :show_by_institution, params: { id: @actionPage.id,
          institution_id: @actionPage.institutions.first.id }
        expect(assigns(:institution)).to eq(@actionPage.institutions.first)

        # it should assign signatures associated with the institution
        # and only show affiliations containing that institution
        signature = @petition.signatures.first
        expect(assigns(:signatures)).to contain_exactly(signature)
        expect(assigns(:signatures).first)
          .to have_attributes(affiliations: [signature.affiliations.first])
      end
    end
  end
end
