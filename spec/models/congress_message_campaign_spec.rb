require "rails_helper"

describe EmailCampaign do
  let(:campaign) { FactoryGirl.create :congress_message_campaign }

  it "generates a url for fills by date" do
    expect(campaign.date_fills_url(Time.zone.today - 30.days, Time.zone.today)).to \
      include("campaign_tag=a+campaign+tag")
    expect(campaign.date_fills_url(Time.zone.today - 30.days, Time.zone.today)).to \
      match(/date_end=\d{4}-\d{2}-\d{2}&date_start=\d{4}-\d{2}-\d{2}/)
  end
end
