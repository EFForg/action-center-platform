class AddEmailCampaignIdToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :email_campaign_id, :integer
  end
end
