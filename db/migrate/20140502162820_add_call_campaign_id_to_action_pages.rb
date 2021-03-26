class AddCallCampaignIdToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :call_campaign_id, :string
  end
end
