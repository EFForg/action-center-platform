require "rails_helper"

describe CongressMessage do
  subject {
    FactoryGirl.build(:congress_message)
  }

  describe "#common_fields" do
    it "groups matching opt_hashes" do
      expect(subject.common_fields.count).to eq 4
    end

    xit "doesn't group mismatched opt_hashes" do
      subject.forms[1].fields.last.options_hash["TEXAS"] = "TX"
      expect(subject.common_fields.count).to eq 0
    end
  end
end
