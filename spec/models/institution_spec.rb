require "rails_helper"

describe Institution do
  describe ".import" do
    let(:action_page) { FactoryBot.create(:action_page) }
    let(:institution) { FactoryBot.create(:institution) }
    let(:names) do
      ["University of California, Berkeley",
       "University of California, Santa Cruz"]
    end

    it "adds institutions by name" do
      expect do
        described_class.import("University", names)
      end.to change(Institution.where(category: "University"), :count).by(names.count)
    end
  end
end
