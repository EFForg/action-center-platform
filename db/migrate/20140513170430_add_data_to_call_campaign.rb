class AddDataToCallCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :call_campaigns, :title, :string
    add_column :call_campaigns, :message, :text
    add_column :call_campaigns, :call_campaign_id, :string
  end
end
