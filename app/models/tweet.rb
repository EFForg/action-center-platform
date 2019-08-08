class Tweet < ActiveRecord::Base
  has_one :action_page
  has_many :tweet_targets
  alias :targets :tweet_targets
  accepts_nested_attributes_for :tweet_targets, reject_if: :all_blank,
    allow_destroy: true

  def target_congress?
    target_house? || target_senate?
  end

  def dup
    super.tap do |tweet|
      tweet_targets.each do |target|
        tweet.tweet_targets.build(twitter_id: target.twitter_id)
      end
    end
  end
end
