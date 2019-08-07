class ActionPageFilters
  def self.run(**data)
    new(**data).run
  end

  def initialize(relation: ActionPage.all, **filters)
    @relation = relation
    @filters = filters
  end

  def run
    process_date_range
    filters.delete :date_range

    filters.each do |f, val|
      next unless valid_query?(f, val)
      @relation = if NAMED_SCOPES.include? f
                    relation.send(f, val)
                  else
                    relation.where(f => val)
                  end
    end
    relation
  end

  private

  NAMED_SCOPES = %i(type status).freeze
  VALID_FILTERS = %i(type status author category).freeze

  attr_accessor :relation, :filters

  def empty_value?(val)
    val.blank? || val == "all"
  end

  def process_date_range
    return unless filters[:date_range].present?
    start_date, end_date = parse_date_range
    @relation = relation.where(created_at: start_date..(end_date + 1.day))
  end

  def parse_date_range
    filters[:date_range].split(" - ").map { |d| Time.zone.parse(d) }
  end

  def valid_query?(f, val)
    validate_filter_name f
    !empty_value? val
  end

  def validate_filter_name(f)
    unless VALID_FILTERS.include? f
      raise ArgumentError, "unrecognized filter #{f}"
    end
  end
end
