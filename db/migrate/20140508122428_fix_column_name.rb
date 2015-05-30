class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :action_pages, :email_campaign_id, :email_campaigns_id
  end
end
