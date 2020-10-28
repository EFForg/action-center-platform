class ActionPage < ActiveRecord::Base
  extend FriendlyId, AmazonCredentials

  include PgSearch
  pg_search_scope :search,
                  against: [
                    :title,
                    :slug,
                    :summary,
                    :description,
                    :email_text,
                  ],
                  associated_against: {
                    call_campaign: [:title, :message],
                    congress_message_campaign: [:subject, :message, :campaign_tag],
                    email_campaign: [:subject, :message],
                    petition: [:title, :description],
                    tweet: [:target, :message, :cta]
                  },
                  using: { tsearch: { prefix: true } }

  friendly_id :title, use: [:slugged, :history]
  scope :published, -> { where(published: true) }

  has_many :events, class_name: Ahoy::Event
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

  has_attached_file :featured_image, amazon_credentials.merge(default_url: "missing.png")
  has_attached_file :background_image, amazon_credentials
  has_attached_file :og_image, amazon_credentials
  validates_media_type_spoof_detection :featured_image,
    if: -> { featured_image.present? && featured_image_file_name_came_from_user? }
  validates_media_type_spoof_detection :background_image,
    if: -> { background_image.present? && background_image_file_name_came_from_user? }
  validates_media_type_spoof_detection :og_image,
    if: -> { og_image.present? && og_image_file_name_came_from_user? }
  do_not_validate_attachment_file_type [:featured_image, :background_image, :og_image]

  #validates_length_of :og_title, maximum: 65
  after_save :no_drafts_on_homepage
  after_save :set_congress_tag, if: -> { enable_congress_message }

  scope :categorized, ->(category) { joins(:category).where(categories: { title: category }) }

  def self.type(*types)
    scopes = Array(types).flatten.map do |t|
      unless %w(call congress_message email petition tweet redirect).include?(t)
        raise ArgumentError, "unrecognized type #{t}"
      end

      where(:"enable_#{t}" => true)
    end

    scopes.inject(:or) || all
  end

  def action_type
    %w(call congress_message email petition tweet redirect).each do |type|
      return type.titleize if self[:"enable_#{type}"]
    end

    nil
  end

  def self.status(status)
    unless %w(archived victory live draft).include?(status)
      raise ArgumentError, "unrecognized status #{status}"
    end
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
      call_campaign.title.length > 0 &&
      call_campaign.title ||
      "Call Your Legislators"
  end

  def message_rendered
    # TODO: just write a test for this and rename this to .to_md
    call_campaign && call_campaign.message || ""
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
    return unless congress_message_campaign.campaign_tag.blank?
    congress_message_campaign.update(campaign_tag: slug)
  end
end
