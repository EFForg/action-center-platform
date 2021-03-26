class RenameActionPagesEmailCampaignsId < ActiveRecord::Migration[5.0]
  def change
    rename_column :action_pages, :email_campaigns_id, :email_campaign_id
  end
end
