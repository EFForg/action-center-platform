require 'amazon_credentials'

class ActionPage < ActiveRecord::Base
  extend FriendlyId, AmazonCredentials

  friendly_id :title, use: [:slugged, :history]
  scope :published, -> { where(published: true) }

  has_many :events, class_name: Ahoy::Event

  belongs_to :petition
  belongs_to :tweet
  belongs_to :email_campaign
  belongs_to :call_campaign
  belongs_to :partner

  accepts_nested_attributes_for :tweet, :petition, :email_campaign,
    :call_campaign, reject_if: :all_blank

  has_attached_file :featured_image, amazon_credentials.merge( default_url: 'missing.png')
  has_attached_file :background_image, amazon_credentials.merge( default_url: "" )
  has_attached_file :og_image, amazon_credentials.merge( :default_url => "" )
  validates_attachment_content_type [:og_image, :background_image, :featured_image],
    :content_type => /\Aimage\/.*\Z/

  #validates_length_of :og_title, maximum: 65
  after_save :no_drafts_on_homepage

  def should_generate_new_friendly_id?
    true
  end
  def call_tool_title
    call_campaign && call_campaign.title.length > 0 && call_campaign.title || 'Call Your Legislators'
  end
  def message_rendered
    # TODO - wrap this in a .to_md
    call_campaign && markdown(call_campaign.message) || ''
  end

  def markdown(blogtext)
    renderOptions = {hard_wrap: true, filter_html: true}
    markdownOptions = {autolink: true, no_intra_emphasis: true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(renderOptions), markdownOptions)
    markdown.render(blogtext).html_safe
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
    unless published?
      FeaturedActionPage.where(action_page_id: id).destroy_all
    end
  end
end
