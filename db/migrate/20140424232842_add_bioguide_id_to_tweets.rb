class AddBioguideIdToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :bioguide_id, :string
  end
end
