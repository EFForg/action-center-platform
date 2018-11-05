module Admin::EventsHelper
  def default_events_start
    (Time.zone.today - 1.month).strftime("%Y-%m-%d") 
  end

  def default_events_end
    Time.zone.today.strftime("%Y-%m-%d")
  end
end
