require 'civicrm'
class User < ActiveRecord::Base
  include CiviCRM::UserMethods
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

  before_update :invalidate_password_reset_tokens, :if => proc { email_changed? }
  before_update :invalidate_new_activists_password, :if => proc { admin_changed?  }
  after_update :reset_password_expiration_flag, :if => proc { encrypted_password_changed? && !password_expired_changed? }

  alias :preferences :user_preferences

  def invalidate_password_reset_tokens
    self.reset_password_token = nil
  end

  def invalidate_new_activists_password
    self.password_expired = true
  end

  def reset_password_expiration_flag
    self.password_expired = false
    self.save
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
    [first_name, last_name].join(' ')
  end

  def percentile_rank
    user_action_counts = Rails.cache.fetch('user_action_counts', :expires_in => 24.hours) {
      User.select( "users.id, count(ahoy_events.id) AS events_count" )
        .joins( "LEFT OUTER JOIN ahoy_events ON ahoy_events.user_id = users.id" )
        .where( "ahoy_events.name IS null OR ahoy_events.name = ?", "Action" )
        .group( "users.id" )
        .map { |u| u.events_count }
    }

    user_count = events.actions.count
    percentile = user_action_counts.percentile_rank(user_count-1).round(0)
  end

  def signed?(petition)
    Signature.where(user: self, petition: petition).exists?
  end

  def taken_action?(action_page)
    actions.on_page(action_page).exists?
  end

  def partner?
    partner.present?
  end

  def self.new_with_session(params, session)
    email = session[:user].with_indifferent_access[:email] if session[:user]
    params.reverse_merge!(email: email)
    new params
  end

  # This is here for collission avoidance when generating new user names in tests
  def self.next_id
    self.last.nil? ? 1 : self.last.id + 1
  end

  protected
  def after_confirmation
    subscribe!(opt_in=true) if self.subscribe?
  end
end
