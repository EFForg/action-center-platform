# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_27_185632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "action_institutions", id: :serial, force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_page_id"], name: "index_action_institutions_on_action_page_id"
    t.index ["institution_id"], name: "index_action_institutions_on_institution_id"
  end

  create_table "action_pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "petition_id"
    t.string "photo_url"
    t.boolean "enable_call", default: false
    t.boolean "enable_petition", default: false
    t.boolean "enable_email", default: false
    t.boolean "enable_tweet", default: false
    t.string "slug"
    t.string "share_message"
    t.integer "tweet_id"
    t.boolean "published", default: false
    t.string "featured_image_file_name"
    t.string "featured_image_content_type"
    t.bigint "featured_image_file_size"
    t.datetime "featured_image_updated_at"
    t.text "what_to_say"
    t.integer "email_campaign_id"
    t.integer "call_campaign_id"
    t.text "summary"
    t.string "background_image_file_name"
    t.string "background_image_content_type"
    t.bigint "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.string "template"
    t.string "layout"
    t.string "og_title"
    t.string "og_image_file_name"
    t.string "og_image_content_type"
    t.bigint "og_image_file_size"
    t.datetime "og_image_updated_at"
    t.boolean "enable_redirect", default: false
    t.string "redirect_url"
    t.text "email_text"
    t.boolean "victory", default: false
    t.text "victory_message"
    t.boolean "archived", default: false
    t.integer "archived_redirect_action_page_id"
    t.integer "category_id"
    t.boolean "enable_congress_message", default: false, null: false
    t.integer "congress_message_campaign_id"
    t.string "related_content_url"
    t.integer "user_id"
    t.integer "view_count", default: 0, null: false
    t.integer "action_count", default: 0, null: false
    t.index ["archived"], name: "index_action_pages_on_archived"
    t.index ["call_campaign_id"], name: "index_action_pages_on_call_campaign_id"
    t.index ["email_campaign_id"], name: "index_action_pages_on_email_campaign_id"
    t.index ["petition_id"], name: "index_action_pages_on_petition_id"
    t.index ["slug"], name: "index_action_pages_on_slug"
    t.index ["tweet_id"], name: "index_action_pages_on_tweet_id"
    t.index ["user_id"], name: "index_action_pages_on_user_id"
  end

  create_table "affiliation_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "action_page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_page_id"], name: "index_affiliation_types_on_action_page_id"
  end

  create_table "affiliations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "signature_id"
    t.integer "institution_id"
    t.integer "affiliation_type_id"
    t.index ["affiliation_type_id"], name: "index_affiliations_on_affiliation_type_id"
    t.index ["institution_id"], name: "index_affiliations_on_institution_id"
    t.index ["signature_id"], name: "index_affiliations_on_signature_id"
  end

  create_table "ahoy_events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "visit_id"
    t.integer "user_id"
    t.string "name"
    t.json "properties"
    t.datetime "time"
    t.integer "action_page_id"
    t.index ["action_page_id"], name: "index_ahoy_events_on_action_page_id"
    t.index ["time"], name: "index_ahoy_events_on_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "bounces", id: :serial, force: :cascade do |t|
    t.string "email"
  end

  create_table "call_campaigns", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "message"
    t.string "call_campaign_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "complaints", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "feedback_type"
    t.string "user_agent"
    t.json "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "congress_members", id: :serial, force: :cascade do |t|
    t.string "full_name", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "bioguide_id", null: false
    t.string "twitter_id"
    t.string "phone"
    t.date "term_end", null: false
    t.string "chamber", null: false
    t.string "state", null: false
    t.integer "district"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "congress_message_campaigns", id: :serial, force: :cascade do |t|
    t.string "subject", null: false
    t.text "message", null: false
    t.string "campaign_tag", null: false
    t.boolean "target_house", default: true, null: false
    t.boolean "target_senate", default: true, null: false
    t.string "target_bioguide_ids"
    t.integer "topic_category_id"
    t.string "alt_text_email_your_rep"
    t.string "alt_text_look_up_your_rep"
    t.string "alt_text_extra_fields_explain"
    t.string "alt_text_look_up_helper"
    t.string "alt_text_customize_message_helper"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable_customization_notice", default: false
  end

  create_table "congress_scorecards", id: :serial, force: :cascade do |t|
    t.string "bioguide_id"
    t.integer "action_page_id"
    t.integer "counter", default: 0
    t.index ["action_page_id", "bioguide_id"], name: "index_congress_scorecards_on_action_page_id_and_bioguide_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "email_campaigns", id: :serial, force: :cascade do |t|
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.string "campaign_tag"
    t.string "email_addresses"
    t.boolean "target_state_lower_chamber"
    t.boolean "target_state_upper_chamber"
    t.boolean "target_governor"
    t.string "state"
  end

  create_table "featured_action_pages", id: :serial, force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "weight"
    t.index ["action_page_id"], name: "index_featured_action_pages_on_action_page_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "institutions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "category", null: false
    t.index ["slug"], name: "index_institutions_on_slug", unique: true
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "privacy_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "deleted_at"
    t.integer "subscriptions_count", default: 0, null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "partnerships", id: :serial, force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "partner_id"
    t.boolean "enable_mailings", default: false, null: false
    t.index ["action_page_id"], name: "index_partnerships_on_action_page_id"
    t.index ["partner_id"], name: "index_partnerships_on_partner_id"
  end

  create_table "petitions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "goal"
    t.boolean "enable_affiliations", default: false
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "signatures", id: :serial, force: :cascade do |t|
    t.integer "petition_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "country_code"
    t.string "zipcode"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.boolean "anonymous", default: false
    t.index ["petition_id"], name: "index_signatures_on_petition_id"
    t.index ["user_id"], name: "index_signatures_on_user_id"
  end

  create_table "source_files", id: :serial, force: :cascade do |t|
    t.string "file_name"
    t.string "file_content_type"
    t.integer "file_size"
    t.string "key"
    t.string "bucket"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topic_categories", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "topic_sets", id: :serial, force: :cascade do |t|
    t.integer "tier"
    t.integer "topic_category_id"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "topic_set_id"
  end

  create_table "tweet_targets", id: :serial, force: :cascade do |t|
    t.integer "tweet_id", null: false
    t.string "twitter_id", null: false
    t.string "bioguide_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["tweet_id"], name: "index_tweet_targets_on_tweet_id"
  end

  create_table "tweets", id: :serial, force: :cascade do |t|
    t.string "target"
    t.string "message"
    t.string "cta"
    t.string "bioguide_id"
    t.boolean "target_house", default: true
    t.boolean "target_senate", default: true
  end

  create_table "user_preferences", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.boolean "admin", default: false
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "country_code"
    t.string "zipcode"
    t.string "phone"
    t.boolean "record_activity", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "contact_id"
    t.boolean "subscribe", default: false
    t.integer "partner_id"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "password_expired"
    t.boolean "collaborator", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "visits", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "visitor_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "referring_domain"
    t.string "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

end
