require "rails_helper"

RSpec.describe "Congress Messages", type: :request do
  let!(:members) {
    [FactoryGirl.create(:congress_member, state: "CA", bioguide_id: "C000880"),
     FactoryGirl.create(:congress_member, state: "CA", bioguide_id: "A000360")]
  }

  let(:action_page) {
    FactoryGirl.create(:action_page_with_congress_message)
  }

  let(:location) {
    OpenStruct.new(success: true,
                   street: "1630 Ravello Drive",
                   city: "Sunnydale",
                   zipcode: 94109,
                   zip4: 1234,
                   state: "CA",
                   district: 10)
  }

  before do
    allow(SmartyStreets).to receive(:get_location).and_return(location)

    stub_request(:post, /retrieve-form-elements/).
      with(body: { "bio_ids" => ["C000880", "A000360"] }).
      and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))
  end

  describe "#new" do
    subject do
      campaign_id = action_page.congress_message_campaign_id
      get("/congress_message_campaigns/#{campaign_id}/congress_messages/new",
          params: { street_address: location.street,
                    zipcode: location.zipcode })
    end

    it "renders the congress message form" do
      subject
      expect(response.body).to include '<input type="text" name="$NAME_FIRST" id="_NAME_FIRST" class="form-control" placeholder="Your first name" aria-label="Your first name" required="required" />'
      # Select from array
      expect(response.body).to include '<option value="Animal_Rights">Animal_Rights</option>'
      # Select from hash
      expect(response.body).to include '<option value="AK">ALASKA</option>'
    end

    it "renders address fields as hidden" do
      subject
      expect(response.body).to include '<input type="hidden" name="$ADDRESS_STREET"'
    end

    it "displays an error when address lookup fails" do
      allow(SmartyStreets).to receive(:get_location)
        .and_return(OpenStruct.new(success: false))
      subject
      expect(response.body).to include "unable to find a congressional district"
    end

    it "displays an error when congress member lookup fails" do
      location.state = "OR"
      allow(SmartyStreets).to receive(:get_location).and_return(location)
      subject
      expect(response.body).to include "unable to find congressional representatives"
    end
  end

  describe "#create" do
    let(:message_attributes) do
      {
        common_attributes: {
          "$NAME_FIRST" => "Joyce",
          "$NAME_LAST" => "Summers",
          "$ADDRESS_STREET" => "1630 Ravello Drive",
          "$ADDRESS_CITY" => "Sunnydale",
          "$ADDRESS_STATE" => "CA",
          "$ADDRESS_ZIP5" => "94109",
          "$EMAIL" => "jsummers@altavista.com",
          "$SUBJECT" => "Take Action",
          "$NAME_PREFIX" => "Mrs.",
          # @TODO auto-fill single options?
          "$ADDRESS_STATE_POSTAL_ABBREV" => "US_STATES_AND_TERRITORIES",
          "$MESSAGE" => "Impeach Mayor Richard Wilkins III"
        },
        member_attributes: {
          "C000880" => {
            "$TOPIC" => "JU",
          },
          "A000360" => {
            "$TOPIC" => "Special_Requests"
          }
        },
        bioguide_ids: ["C000880", "A000360"]
      }
    end

    subject do
      campaign_id = action_page.congress_message_campaign_id
      post("/congress_message_campaigns/#{campaign_id}/congress_messages",
           params: message_attributes )
    end

    before do
      stub_request(:post, /fill-out-form/).
        and_return(status: 200, body: "{}")
    end

    it "successfully submits good input" do
      subject
      expect(WebMock).to have_requested(:post, /fill-out-form/).
        with(body: {
        "bioguide_id":"C000880",
        "fields": {
          "$NAME_FIRST":"Joyce",
          "$NAME_LAST":"Summers",
          "$ADDRESS_STREET":"1630 Ravello Drive",
          "$ADDRESS_CITY":"Sunnydale",
          "$ADDRESS_ZIP5":"94109",
          "$EMAIL":"jsummers@altavista.com",
          "$SUBJECT":"Take Action",
          "$NAME_PREFIX":"Mrs.",
          "$ADDRESS_STATE_POSTAL_ABBREV":"US_STATES_AND_TERRITORIES",
          "$MESSAGE":"Impeach Mayor Richard Wilkins III",
          "$TOPIC":"JU"
        }
      })
    end
  end
end
