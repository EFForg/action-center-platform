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

ActiveRecord::Schema.define(version: 20200324153626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "action_institutions", force: :cascade do |t|
    t.integer  "action_page_id"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["action_page_id"], name: "index_action_institutions_on_action_page_id", using: :btree
    t.index ["institution_id"], name: "index_action_institutions_on_institution_id", using: :btree
  end

  create_table "action_page_images", force: :cascade do |t|
    t.integer  "action_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.string   "action_image",       limit: 255
    t.index ["action_page_id"], name: "index_action_page_images_on_action_page_id", using: :btree
  end

  create_table "action_pages", force: :cascade do |t|
    t.string   "title",                            limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "call_tool"
    t.integer  "petition_id"
    t.string   "photo_url",                        limit: 255
    t.boolean  "enable_call",                                  default: false
    t.boolean  "enable_petition",                              default: false
    t.boolean  "enable_email",                                 default: false
    t.boolean  "enable_tweet",                                 default: false
    t.string   "slug",                             limit: 255
    t.string   "share_message",                    limit: 255
    t.integer  "tweet_id"
    t.boolean  "published",                                    default: false
    t.string   "featured_image_file_name",         limit: 255
    t.string   "featured_image_content_type",      limit: 255
    t.integer  "featured_image_file_size"
    t.datetime "featured_image_updated_at"
    t.string   "action_page_image",                limit: 255
    t.text     "what_to_say"
    t.integer  "email_campaign_id"
    t.integer  "call_campaign_id"
    t.text     "summary"
    t.string   "background_image_file_name",       limit: 255
    t.string   "background_image_content_type",    limit: 255
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.string   "template",                         limit: 255
    t.string   "layout",                           limit: 255
    t.string   "og_title",                         limit: 255
    t.string   "og_image_file_name",               limit: 255
    t.string   "og_image_content_type",            limit: 255
    t.integer  "og_image_file_size"
    t.datetime "og_image_updated_at"
    t.boolean  "enable_redirect",                              default: false
    t.string   "redirect_url",                     limit: 255
    t.text     "email_text"
    t.boolean  "victory",                                      default: false
    t.text     "victory_message"
    t.boolean  "archived",                                     default: false
    t.integer  "archived_redirect_action_page_id"
    t.integer  "category_id"
    t.boolean  "enable_congress_message",                      default: false, null: false
    t.integer  "congress_message_campaign_id"
    t.string   "related_content_url"
    t.integer  "user_id"
    t.integer  "view_count",                                   default: 0,     null: false
    t.integer  "action_count",                                 default: 0,     null: false
    t.index ["archived"], name: "index_action_pages_on_archived", using: :btree
    t.index ["call_campaign_id"], name: "index_action_pages_on_call_campaign_id", using: :btree
    t.index ["email_campaign_id"], name: "index_action_pages_on_email_campaign_id", using: :btree
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
    t.index ["action_page_id"], name: "index_affiliation_types_on_action_page_id", using: :btree
  end

  create_table "affiliations", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "signature_id"
    t.integer  "institution_id"
    t.integer  "affiliation_type_id"
    t.index ["affiliation_type_id"], name: "index_affiliations_on_affiliation_type_id", using: :btree
    t.index ["institution_id"], name: "index_affiliations_on_institution_id", using: :btree
    t.index ["signature_id"], name: "index_affiliations_on_signature_id", using: :btree
  end

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name",           limit: 255
    t.json     "properties"
    t.datetime "time"
    t.integer  "action_page_id"
    t.index ["action_page_id"], name: "index_ahoy_events_on_action_page_id", using: :btree
    t.index ["time"], name: "index_ahoy_events_on_time", using: :btree
    t.index ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree
  end

  create_table "bounces", force: :cascade do |t|
    t.string "email", limit: 255
  end

  create_table "call_campaigns", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",            limit: 255
    t.text     "message"
    t.string   "call_campaign_id", limit: 255
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
    t.string   "subject",                                           null: false
    t.text     "message",                                           null: false
    t.string   "campaign_tag",                                      null: false
    t.boolean  "target_house",                      default: true,  null: false
    t.boolean  "target_senate",                     default: true,  null: false
    t.string   "target_bioguide_ids"
    t.integer  "topic_category_id"
    t.string   "alt_text_email_your_rep"
    t.string   "alt_text_look_up_your_rep"
    t.string   "alt_text_extra_fields_explain"
    t.string   "alt_text_look_up_helper"
    t.string   "alt_text_customize_message_helper"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "enable_customization_notice",       default: false
  end

  create_table "congress_scorecards", force: :cascade do |t|
    t.string  "bioguide_id",    limit: 255
    t.integer "action_page_id"
    t.integer "counter",                    default: 0
    t.index ["action_page_id", "bioguide_id"], name: "index_congress_scorecards_on_action_page_id_and_bioguide_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "email_campaigns", force: :cascade do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject",         limit: 255
    t.string   "campaign_tag",    limit: 255
    t.string   "email_addresses", limit: 255
  end

  create_table "featured_action_pages", force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "weight"
    t.index ["action_page_id"], name: "index_featured_action_pages_on_action_page_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.string   "category",   null: false
    t.index ["slug"], name: "index_institutions_on_slug", unique: true, using: :btree
  end

  create_table "locales", primary_key: "locale", id: :string, limit: 5, force: :cascade do |t|
    t.string "name",     limit: 60, null: false
    t.string "fullname", limit: 60, null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string   "code",                limit: 255
    t.string   "name",                limit: 255
    t.string   "privacy_url",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "deleted_at"
    t.integer  "subscriptions_count",             default: 0, null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "partnerships", force: :cascade do |t|
    t.integer "action_page_id"
    t.integer "partner_id"
    t.boolean "enable_mailings", default: false, null: false
    t.index ["action_page_id"], name: "index_partnerships_on_action_page_id", using: :btree
    t.index ["partner_id"], name: "index_partnerships_on_partner_id", using: :btree
  end

  create_table "petitions", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal"
    t.boolean  "enable_affiliations",             default: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "signatures", force: :cascade do |t|
    t.integer  "petition_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "email",          limit: 255
    t.string   "country_code",   limit: 255
    t.string   "zipcode",        limit: 255
    t.string   "street_address", limit: 255
    t.string   "city",           limit: 255
    t.string   "state",          limit: 255
    t.boolean  "anonymous",                  default: false
    t.index ["petition_id"], name: "index_signatures_on_petition_id", using: :btree
    t.index ["user_id"], name: "index_signatures_on_user_id", using: :btree
  end

  create_table "source_files", force: :cascade do |t|
    t.string   "file_name",         limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_size"
    t.string   "key",               limit: 255
    t.string   "bucket",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "email",      limit: 255
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_categories", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "topic_sets", force: :cascade do |t|
    t.integer "tier"
    t.integer "topic_category_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.integer "topic_set_id"
  end

  create_table "tweet_targets", force: :cascade do |t|
    t.integer  "tweet_id",                       null: false
    t.string   "twitter_id",         limit: 255, null: false
    t.string   "bioguide_id",        limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["tweet_id"], name: "index_tweet_targets_on_tweet_id", using: :btree
  end

  create_table "tweets", force: :cascade do |t|
    t.string  "target",        limit: 255
    t.string  "message",       limit: 255
    t.string  "cta",           limit: 255
    t.string  "bioguide_id",   limit: 255
    t.boolean "target_house",              default: true
    t.boolean "target_senate",             default: true
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "name",       limit: 255, null: false
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_user_preferences_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "location",               limit: 255
    t.boolean  "admin",                              default: false
    t.string   "street_address",         limit: 255
    t.string   "city",                   limit: 255
    t.string   "state",                  limit: 255
    t.string   "country_code",           limit: 255
    t.string   "zipcode",                limit: 255
    t.string   "phone",                  limit: 255
    t.boolean  "record_activity",                    default: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "contact_id"
    t.boolean  "subscribe",                          default: false
    t.integer  "partner_id"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.boolean  "password_expired"
    t.boolean  "collaborator",                       default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip",               limit: 255
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain", limit: 255
    t.string   "search_keyword",   limit: 255
    t.string   "browser",          limit: 255
    t.string   "os",               limit: 255
    t.string   "device_type",      limit: 255
    t.string   "country",          limit: 255
    t.string   "region",           limit: 255
    t.string   "city",             limit: 255
    t.string   "utm_source",       limit: 255
    t.string   "utm_medium",       limit: 255
    t.string   "utm_term",         limit: 255
    t.string   "utm_content",      limit: 255
    t.string   "utm_campaign",     limit: 255
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
  end

end
