require "rails_helper"

describe CongressForms do
  describe CongressForms::Form do
    let(:form) do
      CongressForms::Form.new("C000880", [
                                { "value" => "$NAME_FIRST" },
                                { "value" => "$NAME_LAST" },
                                { "value" => "$ADDRESS_STATE", "options_hash" => {
                                  "CALIFORNIA" => "CA",
                                  "NEW YORK" => "NY"
                                } }
                              ])
    end

    let(:input) do
      {
        "$NAME_FIRST" => "Willow",
        "$NAME_LAST" => "Rosenberg",
        "$MESSAGE" => "Impeach Mayor Richard Wilkins III",
        "$ADDRESS_STATE" => "CA"
      }
    end

    describe "::find" do
      before do
        stub_request(:post, /retrieve-form-elements/)
          .with(body: { "bio_ids" => %w[C000880 A000360] })
          .and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))
      end

      it "retrieves a Form for each bioguide_id" do
        forms = CongressForms::Form.find(%w[C000880 A000360]).first
        expect(forms.length).to eq 2
        lamar = forms.first
        expect(lamar.fields.length).to eq 11
        expect(lamar.fields.first.value).to eq "$NAME_PREFIX"
      end
    end

    describe "#fill" do
      it "posts to the congress forms API" do
        stub_request(:post, /fill-out-form/)
          .and_return(status: 200, body: "{}")
        campaign = FactoryBot.build(:congress_message_campaign)
        form.fill(input, campaign.campaign_tag)
        expect(WebMock).to have_requested(:post, /fill-out-form/)
          .with(body: { bio_id: "C000880", fields: input,
                        campaign_tag: campaign.campaign_tag })
      end
    end
  end
end
