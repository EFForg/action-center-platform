module DateRange
  extend ActiveSupport::Concern

  def start_date
    if params[:date_start]
      Time.zone.parse(params[:date_start])
    else
      (Time.zone.now - 1.month).beginning_of_day
    end
  end

  def end_date
    if params[:date_end]
      Time.zone.parse(params[:date_end])
    else
      Time.zone.now
    end
  end
  
  def start_date_string
    start_date.strftime("%Y-%m-%d")
  end

  def end_date_string
    end_date.strftime("%Y-%m-%d")
  end

  included do
    helper_method :start_date_string
    helper_method :end_date_string
  end
end
