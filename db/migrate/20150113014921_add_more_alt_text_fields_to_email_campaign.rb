class AddMoreAltTextFieldsToEmailCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :alt_text_look_up_helper, :string
    add_column :email_campaigns, :alt_text_customize_message_helper, :string
  end
end
