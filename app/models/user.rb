require "civicrm"
class User < ActiveRecord::Base
  include CiviCRM::UserMethods

  include PgSearch
  pg_search_scope :search, against: [:email, :first_name, :last_name]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         remember_for: 90.days
  has_many :signatures
  has_many :user_preferences
  has_many :events, class_name: Ahoy::Event
  belongs_to :partner
  validates :email, email: true
  validate :password_complexity
  delegate :actions, :views, to: :events
  has_many :action_pages

  before_update :invalidate_password_reset_tokens, if: :email_changed?

  alias_attribute :activist?, :admin?

  alias :preferences :user_preferences

  scope :authors, ->() { joins(:action_pages).distinct }

  def self.group_created_in_range(start_date, end_date)
    if start_date == end_date
      where("created_at BETWEEN ? AND ?", start_date, end_date + 1.day)
        .group_by_hour(:created_at, format: "%Y-%m-%d %H:%M:00 UTC").count
    else
      where("created_at BETWEEN ? AND ?", start_date, end_date)
        .group_by_day(:created_at, format: "%Y-%m-%d 00:00:00 UTC").count
    end
  end

  def invalidate_password_reset_tokens
    self.reset_password_token = nil
  end

  def email_taken?
    errors.added? :email, :taken
  end

  def send_email_taken_notice
    if self.confirmed?
      UserMailer.signup_attempt_with_existing_email(self).deliver_now
    else
      send_confirmation_instructions
    end
  end

  def password_complexity
    if admin? && password.present? and password.length < 30
      errors.add :password, "must be at least 30 (try choosing 6 memorable words)"
    end
  end

  def name
    [first_name, last_name].join(" ")
  end

  def display_name
    return name unless name.blank?
    email
  end

  def percentile_rank
    user_action_counts = Rails.cache.fetch("user_action_counts", expires_in: 24.hours) {
      User.select("users.id, count(ahoy_events.id) AS events_count")
        .joins("LEFT OUTER JOIN ahoy_events ON ahoy_events.user_id = users.id")
        .where("ahoy_events.name IS null OR ahoy_events.name = ?", "Action")
        .group("users.id")
        .map { |u| u.events_count }
    }

    user_count = events.actions.count
    percentile = user_action_counts.percentile_rank(user_count - 1).round(0)
  end

  def signed?(petition)
    return false unless record_activity?

    Signature.where(user: self, petition: petition).exists?
  end

  def taken_action?(action_page)
    return false unless record_activity?

    actions.on_page(action_page).exists?
  end

  def partner?
    partner.present?
  end

  def can?(ability)
    case ability
    when :browse_actions
      admin? || activist? || collaborator?
    when :administer_actions
      admin? || activist?
    when :administer_homepage
      admin? || activist?
    when :view_analytics
      admin? || activist? || collaborator?
    when :administer_partners?
      admin? || activist?
    when :administer_topics?
      admin? || activist?
    when :administer_users?
      admin?
    else
      admin?
    end
  end

  def privileged_role?
    admin? || activist? || collaborator?
  end

  # This is here for collission avoidance when generating new user names in tests
  def self.next_id
    self.last.nil? ? 1 : self.last.id + 1
  end

  # We're allowing unconfirmed users to reset their passwords by
  # re-registering. In that case, they shouldn't get a password reset
  # notification.
  def send_password_change_notification?
    self.confirmed? && super
  end

  protected

  def after_confirmation
    subscribe!(opt_in = true) if self.subscribe?
  end
end
