class CreateCongressMessageCampaigns < ActiveRecord::Migration
  class CongressMessageCampaign < ActiveRecord::Base; end

  def up
    create_table :congress_message_campaigns do |t|
      t.string  :subject,		null: false
      t.text    :message,		null: false
      t.string  :campaign_tag,		null: false
      t.boolean :target_house,		null: false, default: true
      t.boolean :target_senate,		null: false, default: true
      t.string  :target_bioguide_ids
      t.integer :topic_category_id
      t.timestamps			null: false
    end

    add_column :action_pages, :enable_congress_message, :boolean, null: false, default: false
    add_column :action_pages, :congress_message_campaign_id, :integer

    email_actions = ActionPage.joins(:email_campaign).where(enable_email: true)
    email_actions.where("target_senate OR target_house OR target_bioguide_id").find_each do |action_page|
      email_campaign = action_page.email_campaign
      attrs = email_campaign.attributes.slice("subject", "message", "campaign_tag", "topic_category_id",
                                        "target_house", "target_senate", "created_at", "updated_at")
      attrs["target_bioguide_ids"] = email_campaign.bioguide_id.presence if email_campaign.target_bioguide_id?
      attrs["campaign_tag"] = attrs["subject"].underscore if attrs["campaign_tag"].nil?
      congress_campaign = CongressMessageCampaign.create!(attrs)

      attrs = action_page.attributes.except("id", "slug", "enable_email", "email_campaign_id")
      attrs["enable_congress_message"] = true
      attrs["congress_message_campaign_id"] = congress_campaign.id
      ActionPage.create!(attrs)
    end
  end

  def down
    ActionPage.where("enable_congress_message").joins(:congress_message_campaign).destroy_all
    drop_table :congress_message_campaigns
    remove_column :action_pages, :enable_congress_message
    remove_column :action_pages, :congress_message_campaign_id
  end
end
