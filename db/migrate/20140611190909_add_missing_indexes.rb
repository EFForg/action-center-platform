class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :activities, :user_id
    add_index :activities, :action_page_id
    add_index :signatures, :user_id
    add_index :signatures, :petition_id
    add_index :action_pages, :petition_id
    add_index :action_pages, :tweet_id
    add_index :action_pages, :email_campaigns_id
    add_index :action_pages, :call_campaign_id
    add_index :user_preferences, :user_id
    add_index :tweet_targets, :tweet_id
    add_index :featured_action_pages, :action_page_id
  end
end
