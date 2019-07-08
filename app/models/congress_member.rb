class CongressMember < ActiveRecord::Base
  validates_uniqueness_of :bioguide_id

  scope :current, -> { where("? <= term_end", Time.now) }

  scope :filter, ->(f) do
    if f.present?
      fields = "first_name || ' ' || last_name || ' ' || full_name || ' ' || bioguide_id"
      where("LOWER(#{fields}) LIKE ?", "%#{f.downcase}%")
    else
      all
    end
  end

  def current?
    Time.now <= term_end
  end

  def senate?
    chamber == "senate"
  end

  def house?
    chamber == "house"
  end

  def as_json(*args)
    attributes.slice("full_name", "first_name", "last_name", "bioguide_id", "chamber").as_json(*args)
  end

  def self.bioguide_map
    Hash[all.group_by(&:bioguide_id).map { |bio, mem| [bio, mem[0]] }]
  end

  def self.lookup(street:, zipcode:)
    begin
      state, district = SmartyStreets.get_congressional_district(street, zipcode)
    rescue SmartyStreets::AddressNotFound
      return none
    end
    for_district(state, district)
  end

  def self.for_district(state, district)
    current.where(state: state).where("chamber = ? OR district = ?", "senate", district)
  end
end
