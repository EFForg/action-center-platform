class AddCallCampaignIdToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :call_campaign_id, :string
  end
end
