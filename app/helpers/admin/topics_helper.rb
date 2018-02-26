module Admin
  module TopicsHelper
    def topic_category_props(topic_category)
      topic_sets = topic_category.topic_sets.map do |topic_set|
        {
          id: topic_set.id,
          tier: topic_set.tier,
          topics: topic_set.topics.map { |topic| topic.attributes.slice("id", "name") }
        }
      end

      {
        topicCategoryId: topic_category.id,
        topicCategoryName: topic_category.name,
        topicSets: topic_sets
      }
    end
  end
end
