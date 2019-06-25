require "rails_helper"

RSpec.describe "Congress Messages", type: :request do
  let(:members) {
    [FactoryGirl.create(:congress_member, bioguide_id: "C000880"),
     FactoryGirl.create(:congress_member, bioguide_id: "A000360")]
  }

  before do
    allow(CongressMember).to receive(:lookup).and_return(members)

    stub_request(:post, /retrieve-form-elements/).
      with(body: { "bio_ids" => ["C000880", "A000360"] }).
      and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))
  end

  describe "new" do
    subject {
      get("/congress_messages/new",
          params: { street_address: "1630 Revello Drive", zipcode: 94109 })
    }

    it "renders the congress message form" do
      subject
      expect(response.code).to eq "200"
    end
  end
end
