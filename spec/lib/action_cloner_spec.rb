require "rails_helper"

describe ActionCloner do
  it "does not persist action pages" do
    page = FactoryGirl.create(:action_page)
    clone = described_class.run(page)
    expect(clone).not_to be_persisted
  end

  it "returns an ActionPage with cloned attributes" do
    page = FactoryGirl.create(:action_page)
    clone_attrs = filter_attrs(described_class.run(page).attributes)
    expect(clone_attrs).to eq(filter_attrs(page.attributes))
  end

  it "returns a draft action page" do
    page = FactoryGirl.build(:action_page)
    clone = described_class.run(page)
    expect(clone).not_to be_published
  end

  it "does not return an archived page" do
    page = FactoryGirl.build(:action_page, archived: true)
    clone = described_class.run(page)
    expect(clone).not_to be_archived
  end

  it "does not return a victory page" do
    page = FactoryGirl.build(:action_page, victory: true)
    clone = described_class.run(page)
    expect(clone).not_to be_victory
  end

  it "retains its category" do
    page = FactoryGirl.create(:action_page, category: FactoryGirl.build(:category))
    clone = described_class.run(page)
    expect(clone.category.title).to eq(page.category.title)
  end

  it "can be persisted" do
    page = FactoryGirl.create(:action_page)
    clone = described_class.run(page)
    expect(clone.save).to be(true)
  end

  shared_examples "properly duplicates campaign" do |enable_mthd, model|
    let(:page) do
      FactoryGirl.create(:action_page, enable_mthd => true,
                         model => FactoryGirl.create(model))
    end
    let(:clone) { described_class.run(page) }
    it "does not persist" do
      expect(clone.send("#{model}_id")).to be_nil
      expect(clone.send(model)).not_to be_persisted
      expect(filter_attrs(clone.send(model).attributes)).to \
        eq(filter_attrs(page.send(model).attributes))
    end
    it "can be saved" do
      clone.save
      expect(clone.send(model)).to be_persisted
    end
  end

  it_behaves_like "properly duplicates campaign", :enable_tweet, :tweet
  it_behaves_like "properly duplicates campaign", :enable_email, :email_campaign
  it_behaves_like "properly duplicates campaign", :enable_petition, :petition
  it_behaves_like "properly duplicates campaign", :enable_call, :call_campaign
  it_behaves_like "properly duplicates campaign", :enable_congress_message,
    :congress_message_campaign

  def filter_attrs(attrs)
    attrs_not_cloned = %w(published archived created_at updated_at slug id)
    attrs.tap do |hash|
      attrs_not_cloned.each { |a| hash.delete a }
    end
  end
end
