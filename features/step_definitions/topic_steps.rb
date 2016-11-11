
Then /^the topic set containing "([^\"]+)" should be tier ([\d]+)$/ do |topic, tier|
  topic_set = TopicSet.joins(:topics).where(topics: { name: topic }).take!
  expect(topic_set.tier).to eq(tier.to_i)
end
