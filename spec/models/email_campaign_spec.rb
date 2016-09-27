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
        expect(campaign.service_uri(:default)).to eq("mailto:a@example.com,b@example.com?body=hello%20world&subject=hey%20hey%20hey")
      end
    end

    context "service = :gmail" do
      it "should redirect to gmail's mail url" do
        expect(campaign.service_uri(:gmail)).to eq("https://mail.google.com/mail/?view=cm&fs=1&to=a%40example.com%2C%20b%40example.com&body=hello%20world&su=hey%20hey%20hey")
      end
    end

    context "service = :hotmail" do
      it "should redirect to outlook's mail url" do
        expect(campaign.service_uri(:hotmail)).to eq("https://outlook.live.com/default.aspx?rru=compose&to=a%40example.com%2C%20b%40example.com&body=hello%20world&subject=hey%20hey%20hey#page=Compose")
      end
    end
  end
end

