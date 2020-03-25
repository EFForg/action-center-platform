module DateRange
  extend ActiveSupport::Concern

  def set_dates
    @start_date, @end_date = process_dates(**date_params.to_h.symbolize_keys)
  end

  def process_dates(date_range_text: nil, date_text: nil, **_)
    return parse_date_range(date_range_text) if date_range_text.present?
    return [1.month.ago, Time.zone.now] unless date_text.present?
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
    _, count, unit = string.split(" ")
    return Time.zone.now - 1.month unless %w(days weeks months years).include? unit
    Time.zone.now - count.to_i.send(unit)
  end

  def date_range_string
    return "" unless @start_date && @end_date
    format = "%Y-%m-%d"
    "#{@start_date.strftime(format)} - #{@end_date.strftime(format)}"
  end

  def select_time_ago(action_page)
    ["Last 7 days", "Last 30 days", "Last 3 months", "Last 6 months"].tap do |o|
      o << "Action lifetime" if action_page.present?
    end
  end

  included do
    helper_method :date_range_string
    helper_method :select_time_ago
  end

  private

  def date_params
    params.permit(:date_range_text, :date_text)
  end
end
