class AddTargetFlagsToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :target_house, :boolean, default: true
    add_column :tweets, :target_senate, :boolean, default: true
  end
end
