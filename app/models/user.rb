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

  before_update :invalidate_password_reset_tokens, :if => proc { email_changed? }

  alias :preferences :user_preferences

  def invalidate_password_reset_tokens
    self.reset_password_token = nil
  end


  def password_complexity
    if admin? && password.present? and !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

  def name
    [first_name, last_name].join(' ')
  end

  def signed?(petition)
    Signature.where(user: self, petition: petition).exists?
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
