class AddTweetsToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :tweet_id, :integer
  end
end
