require "rails_helper"

describe ApplicationHelper do
  describe "#pluralize_with_span" do
    it "pluralizes when count != 1" do
      expect(helper.pluralize_with_span(0, "mouse")).to eq("<span>0</span> mice")
      expect(helper.pluralize_with_span(3, "mouse")).to eq("<span>3</span> mice")
    end
    it "doesn't pluralize when count == 1" do
      expect(helper.pluralize_with_span(1, "mouse")).to eq("<span>1</span> mouse")
    end
  end
end
