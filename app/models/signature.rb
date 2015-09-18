include GoingPostal
class Signature < ActiveRecord::Base
  belongs_to :user
  belongs_to :petition

  before_validation :format_zipcode
  before_save :sanitize_input
  validates_presence_of :first_name, :last_name, :country_code, :petition_id,
    message: "This can't be blank."

  validates :email, email: true
  validates :zipcode, length: { maximum: 12 }
  validate :country_code, :arbitrary_opinion_of_country_string_validity

  include ActionView::Helpers::DateHelper

  def arbitrary_opinion_of_country_string_validity
    begin
      IsoCountryCodes.find(country_code)
    rescue IsoCountryCodes::UnknownCodeError
      errors.add(:country_code, "Country Code might come from a spam bot.")
    end

  end

  def name
    [first_name, last_name].join(' ')
  end

  def location
    if anonymous
      country_code
    else
      [city, state, country_code].select(&:present?).join(', ')
    end
  end

  def time_ago
    time_ago_in_words(created_at)
  end


  private
  def format_zipcode
    zipcode = GoingPostal.format_zipcode(zipcode, country_code) || zipcode
  end

  def sanitize_input
    self.first_name = Sanitize.clean(first_name)
    self.last_name = Sanitize.clean(last_name)
    self.street_address = Sanitize.clean(street_address)
    self.email = Sanitize.clean(email)
    self.city = Sanitize.clean(city)
    self.state = Sanitize.clean(state)
    self.country_code = Sanitize.clean(country_code)
    self.zipcode = Sanitize.clean(zipcode)
  end

  def validate_zipcode
    unless GoingPostal.valid_zipcode?(zipcode, country_code)
      errors.add(:zipcode, "Invalid zip/postal code for country")
    end
  end
end
