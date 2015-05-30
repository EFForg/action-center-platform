require 'civicrm'
class User < ActiveRecord::Base
  include CiviCRM::UserMethods
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable,
         remember_for: 90.days
  has_many :signatures
  has_many :user_preferences
  has_many :events, class_name: Ahoy::Event
  belongs_to :partner
  validates :email, email: true

  alias :preferences :user_preferences

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

  protected
  def after_confirmation
    subscribe!(opt_in=true) if self.subscribe?
  end
end
