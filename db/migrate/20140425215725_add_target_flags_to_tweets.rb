class AddTargetFlagsToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :target_house, :boolean, default: true
    add_column :tweets, :target_senate, :boolean, default: true
  end
end
