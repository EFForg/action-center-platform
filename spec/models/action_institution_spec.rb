require "rails_helper"

RSpec.describe ActionInstitution, type: :model do
  describe ".add" do
    let!(:page) do
      petition = FactoryBot.create(:petition, enable_affiliations: true)
      FactoryBot.create(:action_page_with_petition, petition: petition)
    end
    let!(:institutions) do
      FactoryBot.create_list(:institution, 2, category: "university")
    end
    it "adds all institutions of a category" do
      described_class.add(action_page: page, category: "university")
      expect(page.reload.institutions).to eq(institutions)
    end
    it "does not create duplicates" do
      2.times { described_class.add(action_page: page, category: "university") }
      expect(page.reload.institutions).to eq(institutions)
    end
    it "adds new institutions in the category" do
      page.institutions << institutions
      new = FactoryBot.create(:institution, category: "university")
      described_class.add(action_page: page, category: "university")
      expect(page.reload.institutions).to eq(institutions + [new])
    end
    it "removes institutions when reset: '1'" do
      page.institutions << institutions
      new = FactoryBot.create(:institution, category: "city")
      described_class.add(action_page: page, category: "city", reset: "1")
      expect(page.reload.institutions).to eq([new])
    end
  end
end
