class ActionPage < ApplicationRecord
  extend FriendlyId

  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[
                    title
                    slug
                    summary
                    description
                    email_text
                  ],
                  associated_against: {
                    call_campaign: %i[title message],
                    congress_message_campaign: %i[subject message campaign_tag],
                    email_campaign: %i[subject message],
                    petition: %i[title description],
                    tweet: %i[target message cta]
                  },
                  using: { tsearch: { prefix: true } }

  friendly_id :title, use: %i[slugged history]
  scope :published, -> { where(published: true) }

  has_many :events, class_name: "Ahoy::Event"
  has_many :partnerships
  has_many :partners, through: :partnerships
  has_many :action_institutions
  has_many :institutions, through: :action_institutions
  has_many :affiliation_types

  belongs_to :petition
  belongs_to :tweet
  belongs_to :email_campaign
  belongs_to :congress_message_campaign
  belongs_to :call_campaign
  belongs_to :category, optional: true
  belongs_to :active_action_page_for_redirect, class_name: "ActionPage",
                                               foreign_key: "archived_redirect_action_page_id"

  belongs_to :author, class_name: "User", foreign_key: :user_id, optional: true


  accepts_nested_attributes_for :tweet, :petition, :email_campaign,
                                :call_campaign, :congress_message_campaign, :affiliation_types, :partnerships,
                                reject_if: :all_blank

  mount_uploader :featured_image, ActionPageImageUploader, mount_on: :featured_image_file_name
  mount_uploader :background_image, ActionPageImageUploader, mount_on: :background_image_file_name
  mount_uploader :og_image, ActionPageImageUploader, mount_on: :og_image_file_name

  after_save :no_drafts_on_homepage
  after_save :set_congress_tag, if: -> { enable_congress_message }

  scope :categorized, ->(category) { joins(:category).where(categories: { title: category }) }

  def self.type(*types)
    scopes = Array(types).flatten.map do |t|
      raise ArgumentError, "unrecognized type #{t}" unless %w[call congress_message email petition tweet redirect].include?(t)

      where("enable_#{t}": true)
    end

    scopes.inject(:or) || all
  end

  def action_type
    %w[call congress_message email petition tweet redirect].each do |type|
      return type.titleize if self[:"enable_#{type}"]
    end

    nil
  end

  def self.status(status)
    raise ArgumentError, "unrecognized status #{status}" unless %w[archived victory live draft].include?(status)

    case status
    when "live"
      where(published: true, archived: false, victory: false)
    when "draft"
      where(published: false, archived: false, victory: false)
    else
      where(status => true)
    end
  end

  def mailing_list_partners
    partnerships.where(enable_mailings: true).partners
  end

  def should_generate_new_friendly_id?
    # create slugs with FriendlyId and respect our custom slugs
    # set a custom slug with `page.update(slug: new_slug)`
    title.present? && (slug.blank? || title_changed?)
  end

  def call_tool_title
    call_campaign &&
      !call_campaign.title.empty? &&
      call_campaign.title ||
      "Call Your Legislators"
  end

  def message_rendered
    # TODO: just write a test for this and rename this to .to_md
    call_campaign&.message || ""
  end

  def verb
    return "sign" if enable_petition?
    return "tweet" if enable_tweet?
  end

  def tweet_individual?
    tweet && tweet.target.present?
  end

  def tweet_congress?
    tweet && tweet.target.blank?
  end

  def redirect_from_archived_to_active_action?
    archived? && active_action_page_for_redirect && !victory?
  end

  def template
    self[:template] || :show
  end

  def layout
    self[:layout] || :default
  end

  def og_title
    self[:og_title].presence || title
  end

  def image
    [og_image, background_image, featured_image].find(&:present?)
  end

  def actions_taken_percent
    return 0 if view_count == 0

    @percent ||= (action_count / view_count.to_f) * 100
  end

  def status
    if archived?
      "archived"
    elsif victory?
      "victory"
    elsif published?
      "live"
    else
      "draft"
    end
  end

  def status=(status)
    case status
    when "live"
      self.published = true
      self.archived = false
      self.victory = false

    when "archived"
      self.published = false
      self.archived = true
      self.victory = false

    when "victory"
      self.published = true
      self.archived = false
      self.victory = true

    when "draft"
      self.published = false
      self.archived = false
      self.victory = false
    end
  end

  def no_drafts_on_homepage
    FeaturedActionPage.where(action_page_id: id).destroy_all unless published?
  end

  def set_congress_tag
    return if congress_message_campaign.campaign_tag.present?

    congress_message_campaign.update(campaign_tag: slug)
  end
end
