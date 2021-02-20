class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :action_pages, :email_campaign_id, :email_campaigns_id
  end
end
