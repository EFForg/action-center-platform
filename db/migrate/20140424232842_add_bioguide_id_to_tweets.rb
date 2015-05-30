class AddBioguideIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :bioguide_id, :string
  end
end
