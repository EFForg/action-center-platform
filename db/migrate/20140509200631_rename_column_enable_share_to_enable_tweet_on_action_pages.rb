class RenameColumnEnableShareToEnableTweetOnActionPages < ActiveRecord::Migration[5.0]
  def change
    change_table :action_pages do |t|
      t.rename :enable_share, :enable_tweet
    end
  end
end
