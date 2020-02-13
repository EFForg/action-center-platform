require "rails_helper"

RSpec.describe Admin::InstitutionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  # This should return the minimal set of attributes required to create a valid
  # Admin::Institution. As you add validations to Admin::InstitutionSet, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "San Francisco State University", category: "University" }
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
      get :index
      expect(assigns(:institutions)).to eq([institution])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new institution" do
        expect {
          post :create, params: { action_page_id: @actionPage.id,
            institution: valid_attributes }
        }.to change(Institution, :count).by(1)
      end

      it "does not create duplicate institutions" do
        institution = Institution.create! valid_attributes
        expect {
          post :create, params: { action_page_id: @actionPage.id,
            institution: valid_attributes }
        }.to_not change(Institution, :count)
      end
    end
  end

  describe "POST #import" do
    let(:import) do
      post :import, params: { file: file, institutions: { category: "University" } }
    end

    let(:import_and_work_off) do
      import
      Delayed::Worker.new.work_off
    end

    context "with valid csv" do
      let(:file) { fixture_file_upload("files/schools.csv") }

      it "queues a job" do
        expect { import }.to change(Delayed::Job, :count).by(1)
      end

      it "uploads institutions" do
        expect(Institution).
          to receive(:import).with(
               "University",
               ["University of California, Berkeley",
                "University of California, Davis",
                "University of California, Santa Cruz"]
             )
        import_and_work_off
      end
    end

    context "with an invalid csv" do
      let(:file) { fixture_file_upload("files/bad_schools.csv") }

      it "does not upload institutions" do
        expect(Institution).not_to receive(:import)
        import_and_work_off
      end

      it "does not queue a job" do
        expect { import }.not_to change(Delayed::Job, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the institution" do
      institution = Institution.create! valid_attributes
      expect {
        delete :destroy, params: { id: institution.to_param }
      }.to change(Institution, :count).by(-1)
    end
  end
end
