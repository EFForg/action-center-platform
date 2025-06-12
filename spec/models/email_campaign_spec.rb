require "rails_helper"

describe EmailCampaign do
  describe "#service_uri(service)" do
    let(:custom_campaign) do
      FactoryBot.create(:email_campaign)
    end

    context "service = :default" do
      it "should redirect to a mailto uri" do
        expect(custom_campaign.service_uri(:default)).to eq("mailto:a@example.com,b@example.com?body=hello%20world&subject=hey%20hey%20hey")
      end
    end

    context "service = :gmail" do
      it "should redirect to gmail's mail url" do
        expect(custom_campaign.service_uri(:gmail)).to eq("https://mail.google.com/mail/?view=cm&fs=1&body=hello+world&su=hey+hey+hey&to=a%40example.com%2C+b%40example.com")
      end
    end

    context "service = :hotmail" do
      it "should redirect to outlook's mail url" do
        expect(custom_campaign.service_uri(:hotmail)).to eq("https://outlook.live.com/default.aspx?rru=compose&body=hello+world&subject=hey+hey+hey&to=a%40example.com%2C+b%40example.com#page=Compose")
      end
    end
  end

  describe "#service_uri(service, opts = {})" do
    let(:state_leg_campaign) do
      FactoryBot.create(:email_campaign, :state_leg)
    end

    context "service = :default, opts = {email: 'state_rep@example.com'}" do
      it "should redirect to a mailto uri" do
        expect(state_leg_campaign.service_uri(:default, { email: "state_rep@example.com" })).to eq("mailto:state_rep@example.com?body=hello%20world&subject=hey%20hey%20hey")
      end
    end

    context "service = :gmail, opts = {email: 'state_rep@example.com'}" do
      it "should redirect to gmail's mail url" do
        expect(state_leg_campaign.service_uri(:gmail, { email: "state_rep@example.com" })).to eq("https://mail.google.com/mail/?view=cm&fs=1&body=hello+world&su=hey+hey+hey&to=state_rep%40example.com")
      end
    end

    context "service = :hotmail, opts = {email: 'state_rep@example.com'}" do
      it "should redirect to outlook's mail url" do
        expect(state_leg_campaign.service_uri(:hotmail, { email: "state_rep@example.com" })).to eq("https://outlook.live.com/default.aspx?rru=compose&body=hello+world&subject=hey+hey+hey&to=state_rep%40example.com#page=Compose")
      end
    end
  end
end
