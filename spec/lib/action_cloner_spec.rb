require "rails_helper"

describe ActionCloner do
  it "does not persist action pages" do
    page = FactoryGirl.create(:action_page)
    clone = described_class.clone(page)
    expect(clone).not_to be_persisted
  end

  it "returns an ActionPage with cloned attributes" do
    page = FactoryGirl.create(:action_page)
    clone_attrs = filter_attrs(described_class.clone(page).attributes)
    expect(clone_attrs).to eq(filter_attrs(page.attributes))
  end

  it "returns a draft action page" do
    page = FactoryGirl.build(:action_page)
    clone = described_class.clone(page)
    expect(clone).not_to be_published
  end

  it "does not return an archived page" do
    page = FactoryGirl.build(:action_page, archived: true)
    clone = described_class.clone(page)
    expect(clone).not_to be_archived
  end

  it "does not return a victory page" do
    page = FactoryGirl.build(:action_page)
    clone = described_class.clone(page)
    expect(clone).not_to be_victory
  end

  context "duplicating campaign associations" do
    xit "tweet association" 
    xit "email association"
    xit "petition"
    xit "congress message"
    xit "call"
  end

  def filter_attrs(attrs)
    attrs_not_cloned = %w(published archived created_at updated_at slug id)
    attrs.tap do |hash|
      attrs_not_cloned.each { |a| hash.delete a }
    end
  end
end
