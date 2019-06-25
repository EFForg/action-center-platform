require "rails_helper"

RSpec.describe "Congress Messages", type: :request do
  let(:members) {
    [FactoryGirl.create(:congress_member, bioguide_id: "C000880"),
     FactoryGirl.create(:congress_member, bioguide_id: "A000360")]
  }

  let(:action_page) {
    FactoryGirl.create(:action_page_with_congress_message)
  }

  before do
    allow(CongressMember).to receive(:lookup).and_return(members)

    stub_request(:post, /retrieve-form-elements/).
      with(body: { "bio_ids" => ["C000880", "A000360"] }).
      and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))
  end

  describe "new" do
    subject {
      get("/congress_messages/new", params: {
          congress_message_campaign_id: action_page.congress_message_campaign_id,
          street_address: "1630 Revello Drive",
          zipcode: 94109
        })
    }

    it "renders the congress message form" do
      subject
      expect(response.code).to eq "200"
      expect(response.body).to include '<input type="text" name="$NAME_FIRST" id="_NAME_FIRST" class="form-control" placeholder="Your first name" aria-label="Your first name" required="required" />'
      # Select from array
      expect(response.body).to include '<option value="Animal_Rights">Animal_Rights</option>'
      # Select from hash
      expect(response.body).to include '<option value="AK">ALASKA</option>'
    end
  end
end
