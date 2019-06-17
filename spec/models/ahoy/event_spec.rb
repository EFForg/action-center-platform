require "rails_helper"

describe Ahoy::Event do
  describe "#types" do
    it "returns event types for an action" do
      action_page = FactoryGirl.create(:action_page_with_tweet)
      expect(Ahoy::Event.action_types(action_page)).to eq([:views, :tweets])
    end
  end
end
