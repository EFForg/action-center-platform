require "rails_helper"

RSpec.describe Admin::PetitionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin_user)
  end

  describe "GET #show" do
    let(:petition) { FactoryGirl.create(:petition) }

    it "assigns @signatures" do
      get :show, params: { id: petition.id, action_page_id: petition.action_page.id }
      expect(assigns(:signatures)).not_to be_nil
      expect(response.status).to eq(200)
    end

    it "passes the 'query' param through Signature.filter" do
      query = "jo@example.com"

      expect(Petition).to receive(:find) { petition }
      expect(petition.signatures).to receive(:filter) do |q|
        expect(q).to eq(query)
        Signature.all
      end

      get :show, params: { id: petition.id, action_page_id: petition.action_page.id, query: query }
      expect(response.status).to eq(200)
    end
  end

  describe "DELETE #destroy_signatures" do
    let(:petition) { FactoryGirl.create(:petition) }
    let(:signatures) do
      30.times.map { FactoryGirl.create(:signature, petition: petition) }
    end

    it "should delete signatures from the signature_ids param" do
      delete :destroy_signatures, params: { id: petition.id, signature_ids: signatures[10..-1].map(&:id) }
      expect(petition.signatures.reload).to contain_exactly(*signatures[0..9])
      expect(response).to redirect_to(admin_action_page_petition_path(petition.action_page, petition))
    end

    it "should redirect back to the same page (or earlier if that page is deleted)" do
      signatures
      delete :destroy_signatures, params: { id: petition.id, signature_ids: [], query: "", page: 2 }
      expect(response).to redirect_to(admin_action_page_petition_path(petition.action_page, petition, query: "", page: 2))

      # there is no page 4, so we expect a redirect to page 3
      delete :destroy_signatures, params: { id: petition.id, signature_ids: [], query: "", page: 4 }
      expect(response).to redirect_to(admin_action_page_petition_path(petition.action_page, petition, query: "", page: 3))
    end
  end
end
