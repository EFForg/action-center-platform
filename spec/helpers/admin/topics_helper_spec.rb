require "rails_helper"

RSpec.describe Admin::TopicsHelper, type: :helper do
  describe "#topic_category_tables_props" do
    it "serializes topic categories for the React on Rails component" do
      topic_category = FactoryBot.create(:topic_category, name: "Privacy")

      props = helper.topic_category_tables_props
      serialized_category = props[:topicCategories].first

      expect(props[:topicCategories].size).to eq(1)
      expect(serialized_category[:topicCategoryId]).to eq(topic_category.id)
      expect(serialized_category[:topicCategoryName]).to eq("Privacy")
      expect(serialized_category[:topicSets].map { |topic_set| topic_set[:tier] }).to match_array(
        topic_category.topic_sets.map(&:tier),
      )
      expect(serialized_category[:topicSets].flat_map { |topic_set| topic_set[:topics] }).to match_array(
        topic_category.topic_sets.flat_map do |topic_set|
          topic_set.topics.map { |topic| topic.attributes.slice("id", "name") }
        end,
      )
    end
  end
end
