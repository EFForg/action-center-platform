module DateRange
  extend ActiveSupport::Concern

  def process_dates(date_range_text: nil, date_text: nil, **_)
    return parse_date_range(date_range_text) if date_range_text.present?
    return [Time.zone.now - 1.month, Time.zone.now] unless date_text.present?
    if date_text == "Action lifetime" && @actionPage.present?
      return [@actionPage.created_at, Time.zone.now]
    end
    [parse_time_ago(date_text), Time.zone.now]
  end

  def parse_date_range(date_range_string)
    date_range_string.split(" - ").map { |d| Time.zone.parse(d) }
  end

  # Convert Last X (days|weeks|months) to a time
  def parse_time_ago(string)
    _, count, unit = string.split(' ')
    return Time.zone.now - 1.month unless %w(days weeks months years).include? unit
    Time.zone.now - count.to_i.send(unit)
  end

  def date_string(date)
    date.strftime("%Y-%m-%d")
  end

  included do
    helper_method :date_string
  end

  private

  def date_params
    params.permit(:date_range_text, :date_text)
  end
end
