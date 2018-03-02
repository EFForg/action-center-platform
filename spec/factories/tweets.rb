FactoryGirl.define do
  factory :tweet do
    message "Please protect my right to use the Internet safely"

    after(:create) do |tweet|
      FactoryGirl.create(:action_page_with_tweet, tweet_id: tweet.id)
    end
  end

  factory :tweet_targeting_senate, parent: :tweet do
    target_senate true
  end
end
