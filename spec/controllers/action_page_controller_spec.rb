require 'rails_helper'

RSpec.describe ActionPageController, type: :controller do
  let(:action_page) { FactoryGirl.create :action_page, title: "Sample Action Page" }

  describe "GET #show" do
    it "redirects to a cannonical url" do
      original_slug = action_page.slug
      action_page.title = "Renamed Sample Action Page"
      action_page.save

      get :show, { :id => original_slug }
      expect(response).to redirect_to action_page
    end

    it "doesn't redirect if the url is already cannonical" do
      get :show, { :id => action_page.slug }
      expect(response.status).to eq(200)
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
        get :show_by_institution, {:id => @actionPage.id,
          :institution_id => @actionPage.institutions.first.id}
        expect(assigns(:institution)).to eq(@actionPage.institutions.first)

        # it should assign signatures associated with the institution
        # and only show affiliations containing that institution
        signature = @petition.signatures.first
        expect(assigns(:signatures)).to contain_exactly(signature)
        expect(assigns(:signatures).first)
          .to have_attributes(:affiliations => [signature.affiliations.first])
      end
    end

    context "csv" do
      render_views
      it "returns a csv with filtered affiliations" do
        get :show_by_institution, {:id => @actionPage.id,
          :institution_id => @actionPage.institutions.first.id,
          :format => 'csv'}

        signature = @petition.signatures.first
        csv_contents = [signature.name,
          signature.affiliations.first.institution.name,
          signature.affiliations.first.affiliation_type.name]
        expect(response.body.strip()).to eq(csv_contents.join(','))
      end
    end
  end

end
