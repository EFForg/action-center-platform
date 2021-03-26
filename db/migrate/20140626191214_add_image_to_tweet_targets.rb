class AddImageToTweetTargets < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :tweet_targets, :image
  end

  def self.down
    remove_attachment :tweet_targets, :image
  end
end
