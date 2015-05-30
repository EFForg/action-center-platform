class CreateTweetTargets < ActiveRecord::Migration
  def change
    create_table :tweet_targets do |t|
      t.integer :tweet_id, null: false
      t.string :twitter_id, null: false
      t.string :bioguide_id
    end
  end
end
