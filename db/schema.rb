# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190808043221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "action_institutions", force: :cascade do |t|
    t.integer  "action_page_id"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "action_institutions", ["action_page_id"], name: "index_action_institutions_on_action_page_id", using: :btree
  add_index "action_institutions", ["institution_id"], name: "index_action_institutions_on_institution_id", using: :btree

  create_table "action_pages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "petition_id"
    t.string   "photo_url"
    t.boolean  "enable_call",                      default: false
    t.boolean  "enable_petition",                  default: false
    t.boolean  "enable_email",                     default: false
    t.boolean  "enable_tweet",                     default: false
    t.string   "slug"
    t.string   "share_message"
    t.integer  "tweet_id"
    t.boolean  "published",                        default: false
    t.string   "featured_image_file_name"
    t.string   "featured_image_content_type"
    t.integer  "featured_image_file_size"
    t.datetime "featured_image_updated_at"
    t.text     "what_to_say"
    t.integer  "email_campaign_id"
    t.integer  "call_campaign_id"
    t.text     "summary"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.string   "template"
    t.string   "layout"
    t.string   "og_title"
    t.string   "og_image_file_name"
    t.string   "og_image_content_type"
    t.integer  "og_image_file_size"
    t.datetime "og_image_updated_at"
    t.boolean  "enable_redirect",                  default: false
    t.string   "redirect_url"
    t.text     "email_text"
    t.boolean  "old_victory",                                  default: false
    t.text     "victory_message"
    t.boolean  "old_archived",                                 default: false
    t.integer  "archived_redirect_action_page_id"
    t.integer  "category_id"
    t.boolean  "enable_congress_message",          default: false, null: false
    t.integer  "congress_message_campaign_id"
    t.string   "related_content_url"
    t.integer  "user_id"
    t.integer  "status",                                       default: 0,     null: false
    t.index ["call_campaign_id"], name: "index_action_pages_on_call_campaign_id", using: :btree
    t.index ["email_campaign_id"], name: "index_action_pages_on_email_campaign_id", using: :btree
    t.index ["old_archived"], name: "index_action_pages_on_old_archived", using: :btree
    t.index ["petition_id"], name: "index_action_pages_on_petition_id", using: :btree
    t.index ["slug"], name: "index_action_pages_on_slug", using: :btree
    t.index ["tweet_id"], name: "index_action_pages_on_tweet_id", using: :btree
    t.index ["user_id"], name: "index_action_pages_on_user_id", using: :btree
  end

  create_table "affiliation_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "action_page_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "affiliation_types", ["action_page_id"], name: "index_affiliation_types_on_action_page_id", using: :btree

  create_table "affiliations", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "signature_id"
    t.integer  "institution_id"
    t.integer  "affiliation_type_id"
  end

  add_index "affiliations", ["affiliation_type_id"], name: "index_affiliations_on_affiliation_type_id", using: :btree
  add_index "affiliations", ["institution_id"], name: "index_affiliations_on_institution_id", using: :btree
  add_index "affiliations", ["signature_id"], name: "index_affiliations_on_signature_id", using: :btree

  create_table "ahoy_events", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
    t.integer  "action_page_id"
  end

  add_index "ahoy_events", ["action_page_id"], name: "index_ahoy_events_on_action_page_id", using: :btree
  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "bounces", force: :cascade do |t|
    t.string "email"
  end

  create_table "call_campaigns", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "message"
    t.string   "call_campaign_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complaints", force: :cascade do |t|
    t.string   "email"
    t.string   "feedback_type"
    t.string   "user_agent"
    t.json     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "congress_members", force: :cascade do |t|
    t.string   "full_name",   null: false
    t.string   "first_name",  null: false
    t.string   "last_name",   null: false
    t.string   "bioguide_id", null: false
    t.string   "twitter_id"
    t.string   "phone"
    t.date     "term_end",    null: false
    t.string   "chamber",     null: false
    t.string   "state",       null: false
    t.integer  "district"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "congress_message_campaigns", force: :cascade do |t|
    t.string   "subject",                                          null: false
    t.text     "message",                                          null: false
    t.string   "campaign_tag",                                     null: false
    t.boolean  "target_house",                      default: true, null: false
    t.boolean  "target_senate",                     default: true, null: false
    t.string   "target_bioguide_ids"
    t.integer  "topic_category_id"
    t.string   "alt_text_email_your_rep"
    t.string   "alt_text_look_up_your_rep"
    t.string   "alt_text_extra_fields_explain"
    t.string   "alt_text_look_up_helper"
    t.string   "alt_text_customize_message_helper"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "congress_scorecards", force: :cascade do |t|
    t.string  "bioguide_id"
    t.integer "action_page_id"
    t.integer "counter",        default: 0
  end

  add_index "congress_scorecards", ["action_page_id", "bioguide_id"], name: "index_congress_scorecards_on_action_page_id_and_bioguide_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "email_campaigns", force: :cascade do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.string   "campaign_tag"
    t.string   "email_addresses"
  end

  create_table "featured_action_pages", force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "weight"
  end

  add_index "featured_action_pages", ["action_page_id"], name: "index_featured_action_pages_on_action_page_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  add_index "institutions", ["slug"], name: "index_institutions_on_slug", unique: true, using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "privacy_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "deleted_at"
    t.integer  "subscriptions_count", default: 0, null: false
  end

  create_table "partnerships", force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "partner_id"
  end

  add_index "partnerships", ["action_page_id"], name: "index_partnerships_on_action_page_id", using: :btree
  add_index "partnerships", ["partner_id"], name: "index_partnerships_on_partner_id", using: :btree

  create_table "petitions", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal"
    t.boolean  "enable_affiliations", default: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "signatures", force: :cascade do |t|
    t.integer  "petition_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "country_code"
    t.string   "zipcode"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.boolean  "anonymous",      default: false
  end

  add_index "signatures", ["petition_id"], name: "index_signatures_on_petition_id", using: :btree
  add_index "signatures", ["user_id"], name: "index_signatures_on_user_id", using: :btree

  create_table "source_files", force: :cascade do |t|
    t.string   "file_name"
    t.string   "file_content_type"
    t.integer  "file_size"
    t.string   "key"
    t.string   "bucket"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "topic_sets", force: :cascade do |t|
    t.integer "tier"
    t.integer "topic_category_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string  "name"
    t.integer "topic_set_id"
  end

  create_table "tweet_targets", force: :cascade do |t|
    t.integer  "tweet_id",           null: false
    t.string   "twitter_id",         null: false
    t.string   "bioguide_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "tweet_targets", ["tweet_id"], name: "index_tweet_targets_on_tweet_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.string  "target"
    t.string  "message"
    t.string  "cta"
    t.string  "bioguide_id"
    t.boolean "target_house",  default: true
    t.boolean "target_senate", default: true
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_preferences", ["user_id"], name: "index_user_preferences_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.boolean  "admin",                  default: false
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "country_code"
    t.string   "zipcode"
    t.string   "phone"
    t.boolean  "record_activity",        default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "contact_id"
    t.boolean  "subscribe",              default: false
    t.integer  "partner_id"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "password_expired"
    t.boolean  "collaborator",           default: false, null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "visits", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
