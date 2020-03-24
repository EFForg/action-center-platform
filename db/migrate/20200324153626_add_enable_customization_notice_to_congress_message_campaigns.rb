class AddEnableCustomizationNoticeToCongressMessageCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :congress_message_campaigns, :enable_customization_notice, :boolean, default: false
  end
end
