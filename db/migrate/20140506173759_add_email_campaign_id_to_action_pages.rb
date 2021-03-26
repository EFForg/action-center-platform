class AddEmailCampaignIdToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :email_campaign_id, :integer
  end
end
