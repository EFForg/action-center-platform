class AddAltTextFieldsToEmailCampaign < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :alt_text_email_your_rep, :string
    add_column :email_campaigns, :alt_text_look_up_your_rep, :string
    add_column :email_campaigns, :alt_text_extra_fields_explain, :string
  end
end
