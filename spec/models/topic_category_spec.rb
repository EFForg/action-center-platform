require "rails_helper"

describe TopicCategory do
  subject { FactoryGirl.create(:topic_category) }
  
  describe "#best_match" do
    it "selects the best match from a list of options" do
      options = ["Spike", "Vampire3", "Drusilla", "Vampire2", "Harmony"]
      expect(subject.best_match options).to eq "Vampire2"
    end

    it "ignores case, whitespace, and punctuation when matching" do
      options = ["Vampire3", "VamPire 2!"]
      expect(subject.best_match options).to eq "VamPire 2!"
    end

    after do
      FactoryGirl.reload
    end
  end
end

