class RenameColumnEnableShareToEnableTweetOnActionPages < ActiveRecord::Migration
  def change
    change_table :action_pages do |t|
      t.rename :enable_share, :enable_tweet
    end
  end
end
