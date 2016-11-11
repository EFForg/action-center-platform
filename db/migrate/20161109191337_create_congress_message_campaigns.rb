class CreateCongressMessageCampaigns < ActiveRecord::Migration
  class CongressMessageCampaign < ActiveRecord::Base
    has_one :action_page
  end

  def up
    create_table :congress_message_campaigns do |t|
      t.string  :subject,		null: false
      t.text    :message,		null: false
      t.string  :campaign_tag,		null: false
      t.boolean :target_house,		null: false, default: true
      t.boolean :target_senate,		null: false, default: true
      t.string  :target_bioguide_ids
      t.integer :topic_category_id
      t.string  :alt_text_email_your_rep
      t.string  :alt_text_look_up_your_rep
      t.string  :alt_text_extra_fields_explain
      t.string  :alt_text_look_up_helper
      t.string  :alt_text_customize_message_helper
      t.timestamps			null: false
    end

    add_column :action_pages, :enable_congress_message, :boolean, null: false, default: false
    add_column :action_pages, :congress_message_campaign_id, :integer

    email_actions = ActionPage.joins(:email_campaign).where(enable_email: true)
    email_actions.where("target_senate OR target_house OR target_bioguide_id").find_each do |action_page|
      email_campaign = action_page.email_campaign
      attrs = email_campaign.attributes.slice("subject", "message", "campaign_tag", "topic_category_id",
                                              "target_house", "target_senate", "created_at", "updated_at",
                                              "alt_text_email_your_rep", "alt_text_look_up_your_rep",
                                              "alt_text_extra_fields_explain", "alt_text_look_up_helper",
                                              "alt_text_customize_message_helper")
      attrs["target_bioguide_ids"] = email_campaign.bioguide_id.presence if email_campaign.target_bioguide_id?
      attrs["campaign_tag"] = action_page.title if attrs["campaign_tag"].nil?
      congress_campaign = CongressMessageCampaign.create!(attrs)

# use these lines instead of the following ones to duplicate email campaigns instead of replacing them
#      attrs = action_page.attributes.except("id", "slug", "enable_email", "email_campaign_id")
#      attrs["enable_congress_message"] = true
#      attrs["congress_message_campaign_id"] = congress_campaign.id
#      congress_action_page = ActionPage.create!(attrs)
      action_page.update_attributes(enable_email: false, enable_congress_message: true,
                                    congress_message_campaign_id: congress_campaign.id)
      congress_action_page = action_page

      Ahoy::Event.emails.on_page(action_page.id).find_each do |event|
        attrs = event.attributes.except("id", "visit_id", "action_page_id")
        attrs["action_page_id"] = congress_action_page.id
        attrs["properties"]["actionType"] = "congress_message"
        attrs["properties"]["actionPageId"] = congress_action_page.id.to_s
# use these lines if you are duplicating instead of replacing
#        attrs["id"] = SecureRandom.uuid
#        Ahoy::Event.create!(attrs)
        event.update_attributes!(attrs)
      end
    end

# if duplicating instead of replacing, comment all this
    remove_column :email_campaigns, :target_house
    remove_column :email_campaigns, :target_senate
    remove_column :email_campaigns, :target_bioguide_id
    remove_column :email_campaigns, :bioguide_id
    remove_column :email_campaigns, :topic_category_id
    remove_column :email_campaigns, :target_email
    remove_column :email_campaigns, :alt_text_email_your_rep
    remove_column :email_campaigns, :alt_text_look_up_your_rep
    remove_column :email_campaigns, :alt_text_extra_fields_explain
    remove_column :email_campaigns, :alt_text_look_up_helper
    remove_column :email_campaigns, :alt_text_customize_message_helper
  end

  def down
# if duplicating instead of replacing, comment all this
    add_column :email_campaigns, :target_house, :boolean, default: true
    add_column :email_campaigns, :target_senate, :boolean, default: true
    add_column :email_campaigns, :target_bioguide_id, :boolean, default: false
    add_column :email_campaigns, :target_email, :boolean
    add_column :email_campaigns, :bioguide_id, :string
    add_column :email_campaigns, :topic_category_id, :integer
    add_column :email_campaigns, :alt_text_email_your_rep, :string
    add_column :email_campaigns, :alt_text_look_up_your_rep, :string
    add_column :email_campaigns, :alt_text_extra_fields_explain, :string
    add_column :email_campaigns, :alt_text_look_up_helper, :string
    add_column :email_campaigns, :alt_text_customize_message_helper, :string

    CongressMessageCampaign.find_each do |congress_campaign|
      action_page = congress_campaign.action_page
      next if action_page.nil?

      attrs = congress_campaign.attributes.slice("subject", "message", "campaign_tag", "topic_category_id",
                                                 "target_house", "target_senate", "created_at", "updated_at",
                                                 "alt_text_email_your_rep", "alt_text_look_up_your_rep",
                                                 "alt_text_extra_fields_explain", "alt_text_look_up_helper",
                                                 "alt_text_customize_message_helper")
      attrs["target_bioguide_id"] = !!congress_campaign.target_bioguide_ids
      attrs["bioguide_id"] = congress_campaign.target_bioguide_ids
      attrs["target_email"] = false

      email_campaign = EmailCampaign.create!(attrs)
      action_page.update_attributes(enable_email: true, email_campaign_id: email_campaign.id)
    end

# if duplicating instead of replacing
#    ActionPage.where("enable_congress_message").joins(:congress_message_campaign).destroy_all
#    Ahoy::Event.where("properties ->> 'actionType' = 'congress_message'").delete_all
    ActionPage.where("enable_congress_message").update_all(enable_email: true)
    Ahoy::Event.where("properties ->> 'actionType' = 'congress_message'").find_each do |event|
      event.update_attributes(properties: event.properties.merge("actionType" => "email"))
    end

    drop_table :congress_message_campaigns
    remove_column :action_pages, :enable_congress_message
    remove_column :action_pages, :congress_message_campaign_id
  end
end
