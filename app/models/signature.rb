class Signature < ActiveRecord::Base
  include GoingPostal

  belongs_to :user
  belongs_to :petition
  has_many :affiliations

  before_validation :format_zipcode
  before_save :sanitize_input
  validates :first_name, :last_name, :petition_id,
            presence: { message: "This can't be blank." }

  validates :country_code, presence: { if: :location_required? }

  validates :email, email: true
  validates :email, uniqueness: { scope: :petition_id,
                                  message: "You've already signed this petition!" }
  validates :zipcode, length: { maximum: 12 }
  validate :country_code, :arbitrary_opinion_of_country_string_validity

  accepts_nested_attributes_for :affiliations, reject_if: :all_blank

  scope :search, lambda { |f|
    if f.present?
      where("LOWER(email) LIKE ? " \
            "OR LOWER(first_name || ' ' || last_name) LIKE ?",
            "%#{f}%".downcase, "%#{f}%".downcase)
    else
      all
    end
  }

  include ActionView::Helpers::DateHelper

  def self.to_csv(options = {})
    column_names = %w[first_name last_name email zipcode country_code created_at]

    CSV.generate(options) do |csv|
      csv << column_names

      all.find_each do |sub|
        csv << sub.attributes.values_at(*column_names)
      end
    end
  end

  def self.to_presentable_csv(options = {})
    column_names = %w[full_name email city state country]

    CSV.generate(options) do |csv|
      csv << column_names

      all.find_each do |signature|
        csv << signature.to_csv_line
      end
    end
  end

  def self.to_affiliation_csv(options = {})
    column_names = %w[full_name institution affiliation_type]

    CSV.generate(options) do |csv|
      csv << column_names

      all.find_each do |s|
        affiliation = s.affiliations.first or next

        csv << [
          s.name,
          affiliation.institution.name,
          affiliation.affiliation_type.name
        ]
      end
    end
  end

  def self.institutions
    joins(affiliations: :institution)
      .distinct.pluck("institutions.name, institutions.id").sort
  end

  def self.pretty_count
    ActiveSupport::NumberHelper.number_to_delimited(count, delimiter: ",")
  end

  def arbitrary_opinion_of_country_string_validity
    errors.add(:country_code, "Country Code might come from a spam bot.") if country_code.present? && full_country_name.nil?
  end

  def name
    [first_name, last_name].join(" ")
  end

  def location
    if anonymous
      country_code
    else
      [city, state, country_code].select(&:present?).join(", ")
    end
  end

  def time_ago
    time_ago_in_words(created_at)
  end

  def to_csv_line
    [name, email, city, state_symbol, full_country_name]
  end

  def state_symbol
    Places.us_state_codes[state]
  end

  def location_required?
    petition.present? && !petition.enable_affiliations
  end

  def full_country_name
    IsoCountryCodes.find(country_code).name
  rescue IsoCountryCodes::UnknownCodeError
    nil
  end

  private

  def format_zipcode
    self.zipcode = GoingPostal.format_zipcode(zipcode, country_code) || zipcode
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
    errors.add(:zipcode, "Invalid zip/postal code for country") unless GoingPostal.valid_zipcode?(zipcode, country_code)
  end
end
