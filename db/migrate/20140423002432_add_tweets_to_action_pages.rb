class AddTweetsToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :tweet_id, :integer
  end
end
