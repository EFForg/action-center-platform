class AddDataToCallCampaign < ActiveRecord::Migration
  def change
    add_column :call_campaigns, :title, :string
    add_column :call_campaigns, :message, :text
    add_column :call_campaigns, :call_campaign_id, :string
  end
end
