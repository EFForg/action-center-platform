class RenameActionPagesEmailCampaignsId < ActiveRecord::Migration
  def change
    rename_column :action_pages, :email_campaigns_id, :email_campaign_id
  end
end
