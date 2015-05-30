class AddImageToTweetTargets < ActiveRecord::Migration
  def self.up
    add_attachment :tweet_targets, :image
  end

  def self.down
    remove_attachment :tweet_targets, :image
  end
end
