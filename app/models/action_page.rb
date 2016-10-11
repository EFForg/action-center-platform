class ActionPage < ActiveRecord::Base
  extend FriendlyId, AmazonCredentials

  friendly_id :title, use: [:slugged, :history]
  scope :published, -> { where(published: true) }

  has_many :events, class_name: Ahoy::Event
  has_many :action_institutions
  has_many :institutions, through: :action_institutions
  has_many :affiliation_types

  belongs_to :petition
  belongs_to :tweet
  belongs_to :email_campaign
  belongs_to :call_campaign
  belongs_to :partner
  belongs_to :active_action_page_for_redirect, :class_name => "ActionPage",
             :foreign_key => "archived_redirect_action_page_id"

  accepts_nested_attributes_for :tweet, :petition, :email_campaign,
    :call_campaign, reject_if: :all_blank

  has_attached_file :featured_image, amazon_credentials.merge( default_url: 'missing.png')
  has_attached_file :background_image, amazon_credentials.merge( default_url: "" )
  has_attached_file :og_image, amazon_credentials.merge( :default_url => "" )
  validates_attachment_content_type [:og_image, :background_image, :featured_image],
    :content_type => /\Aimage\/.*\Z/

  #validates_length_of :og_title, maximum: 65
  before_validation :normalize_blank_issue
  after_save :no_drafts_on_homepage

  def should_generate_new_friendly_id?; true; end # related to friendly_id

  def call_tool_title
    call_campaign && call_campaign.title.length > 0 && call_campaign.title || 'Call Your Legislators'
  end

  def message_rendered
    # TODO - just write a test for this and rename this to .to_md
    call_campaign && call_campaign.message || ''
  end

  def verb
    return 'sign' if enable_petition?
    return 'tweet' if enable_tweet?
  end

  def tweet_individual?
    tweet && tweet.target.present?
  end

  def tweet_congress?
    tweet && !(tweet.target.present?)
  end

  def redirect_from_archived_to_active_action?
    archived? and active_action_page_for_redirect and !victory?
  end

  def template
    self[:template]  || :show
  end

  def layout
    self[:layout] || :default
  end

  def og_title
    self[:og_title].presence || title
  end

  def image
    og_image || background_image || featured_image
  end

  def no_drafts_on_homepage
    FeaturedActionPage.where(action_page_id: id).destroy_all unless published?
  end

  protected

  def normalize_blank_issue
    self.issue = nil if issue.blank?
  end
end
