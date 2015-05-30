class ChangeCallCampaignId < ActiveRecord::Migration
  def change
    remove_column :action_pages, :call_campaign_id
    add_column :action_pages, :call_campaign_id, :integer  
  end
end
