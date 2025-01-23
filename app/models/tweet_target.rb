class TweetTarget < ApplicationRecord
  belongs_to :tweet

  def url
    "https://twitter.com/#{twitter_id}"
  end
end
