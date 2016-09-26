require "rails_helper"

describe EmailCampaign do
  describe "#service_uri(service)" do
    let(:campaign) do
      FactoryGirl.create(:email_campaign, target_email: true, target_senate: false, target_house: false,
                         email_addresses: "a@example.com, b@example.com",
                         subject: "hey hey hey", message: "hello world")
    end

    context "service = :default" do
      it "should redirect to a mailto uri" do
        expect(campaign.service_uri(:default)).to eq("mailto:a@example.com,b@example.com?body=hello+world&subject=hey+hey+hey")
      end
    end

    context "service = :gmail" do
      it "should redirect to gmail's mail url" do
        expect(campaign.service_uri(:gmail)).to eq("https://mail.google.com/mail/?view=cm&fs=1&to=a@example.com,b@example.com&body=hello+world&su=hey+hey+hey")
      end
    end

    context "service = :hotmail" do
      it "should redirect to outlook's mail url" do
        expect(campaign.service_uri(:hotmail)).to eq("https://outlook.live.com/default.aspx?rru=compose&to=a@example.com,b@example.com&body=hello+world&subject=hey+hey+hey#page=Compose")
      end
    end
  end
end

