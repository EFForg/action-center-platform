
require "rails_helper"

describe EmailCampaign do
  let(:campaign) { FactoryGirl.create :congress_message_campaign }

  it "generates a url for fills by date" do
    expect(campaign.date_fills_url(Date.today - 30.days, Date.today)).to include "campaign_tag=a+campaign+tag"
    expect(campaign.date_fills_url(Date.today - 30.days, Date.today)).to match /date_end=\d{4}-\d{2}-\d{2}&date_start=\d{4}-\d{2}-\d{2}/
  end
end
