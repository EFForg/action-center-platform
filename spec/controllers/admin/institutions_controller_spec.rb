require 'rails_helper'

RSpec.describe Admin::InstitutionsController, type: :controller do
  include Devise::TestHelpers

  # This should return the minimal set of attributes required to create a valid
  # Admin::Institution. As you add validations to Admin::InstitutionSet, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "San Francisco State University" }
  }

  before(:each) do
    # Admin login
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin_user)

    # Set parent action
    @actionPage = FactoryGirl.create(:action_page_with_petition)
  end

  describe "GET #index" do
    it "assigns all actionPage.institutions as @institutions" do
      institution = Institution.create! valid_attributes
      @actionPage.institutions << institution
      get :index, {:action_page_id => @actionPage.id}
      expect(assigns(:institutions)).to eq([institution])
    end

    it "does not show institutions not linked to the action page" do
      institution = Institution.create! valid_attributes
      get :index, { :action_page_id => @actionPage.id }
      expect(assigns(:institutions)).to be_empty
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new institution" do
        expect {
          post :create, {:action_page_id => @actionPage.id,
            :institution => valid_attributes}
        }.to change(Institution, :count).by(1)
      end

      it "adds the institution to the action" do
        expect {
          post :create, {:action_page_id => @actionPage.id,
            :institution => valid_attributes}
        }.to change(@actionPage.institutions, :count).by(1)
      end

      it "does not create duplicate institutions" do
        institution = Institution.create! valid_attributes
        @actionPage.institutions << institution
        expect {
          post :create, {:action_page_id => @actionPage.id,
            :institution => valid_attributes}
        }.to_not change(Institution, :count)
      end

      it "redirects to the action's institutions overview" do
        post :create, {:action_page_id => @actionPage.id,
          :institution => valid_attributes}
        expect(response).to redirect_to([:admin, @actionPage, Institution])
      end
    end
  end

  describe "POST #import" do
    context "with valid csv" do
      let(:file) {
        fixture_file_upload('files/schools.csv')
      }

      it "does not remove existing institutions from the action" do
        expect {
          institution = Institution.create! valid_attributes
          @actionPage.institutions << institution

          post :import, {:action_page_id => @actionPage.id,
            :file => file}
        }.to change(@actionPage.institutions, :count).by(4)
      end

      it "uploads institutions from a csv" do
        expect {
          post :import, {:action_page_id => @actionPage.id,
            :file => file}
        }.to change(Institution, :count).by(3)
      end
    end

    context "with an invalid csv" do
      let(:file) {
        fixture_file_upload('files/bad_schools.csv')
      }

      it "handles formatting errors" do
        expect {
          post :import, {:action_page_id => @actionPage.id,
            :file => file}
        }.to change(Institution, :count).by(0)
        expect(flash[:notice]).to include("Import failed")
      end
    end
  end

  describe "DELETE #destroy" do
    it "unlinks the institution from the action" do
      institution = Institution.create! valid_attributes
      @actionPage.institutions << institution
      expect {
        delete :destroy, {:action_page_id => @actionPage.id,
          :id => institution.to_param}
      }.to change(@actionPage.institutions, :count).by(-1)
    end

    it "doesn't delete the institution" do
      institution = Institution.create! valid_attributes
      @actionPage.institutions << institution
      expect {
        delete :destroy, {:action_page_id => @actionPage.id,
          :id => institution.to_param}
      }.to_not change(Institution, :count)
    end

    it "redirects to the institution_sets list" do
      institution = Institution.create! valid_attributes
      @actionPage.institutions << institution
      delete :destroy, {:action_page_id => @actionPage.id,
        :id => institution.to_param}
      expect(response).to redirect_to([:admin, @actionPage, Institution])
    end
  end

end
