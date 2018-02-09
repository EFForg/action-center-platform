require "rails_helper"

RSpec.describe Admin::AffiliationTypesController, type: :controller do
  include Devise::TestHelpers

  # This should return the minimal set of attributes required to create a valid
  # Admin::AffiliationType. As you add validations to Admin::AffiliationType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "Community Member" }
  }

  before(:each) do
    # Admin login
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin_user)

    # Set parent action
    @actionPage = FactoryGirl.create(:action_page_with_petition)
  end

  describe "GET #index" do
    it "assigns all actionPage.affiliation_types as @affiliation_types" do
      affiliation_type = AffiliationType.create! valid_attributes
      @actionPage.affiliation_types << affiliation_type
      get :index, {action_page_id: @actionPage.id}
      expect(assigns(:affiliation_types)).to eq([affiliation_type])
    end

    it "does not show affiliation_types not linked to the action page" do
      affiliation_type = AffiliationType.create! valid_attributes
      get :index, { action_page_id: @actionPage.id }
      expect(assigns(:affiliation_types)).to be_empty
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new affiliation_type" do
        expect {
          post :create, {action_page_id: @actionPage.id,
            affiliation_type: valid_attributes}
        }.to change(AffiliationType, :count).by(1)
      end

      it "adds the affiliation_type to the action" do
        expect {
          post :create, {action_page_id: @actionPage.id,
            affiliation_type: valid_attributes}
        }.to change(@actionPage.affiliation_types, :count).by(1)
      end

      it "redirects to the action's affiliation_types overview" do
        post :create, {action_page_id: @actionPage.id,
          affiliation_type: valid_attributes}
        expect(response).to redirect_to([:admin, @actionPage, AffiliationType])
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested affiliation_type" do
      affiliation_type = AffiliationType.create! valid_attributes
      @actionPage.affiliation_types << affiliation_type
      expect {
        delete :destroy, {action_page_id: @actionPage.id,
          id: affiliation_type.to_param}
      }.to change(AffiliationType, :count).by(-1)
    end

    it "redirects to the affiliation_types list" do
      affiliation_type = AffiliationType.create! valid_attributes
      @actionPage.affiliation_types << affiliation_type
      delete :destroy, {action_page_id: @actionPage.id,
        id: affiliation_type.to_param}
      expect(response).to redirect_to([:admin, @actionPage, AffiliationType])
    end
  end
end
