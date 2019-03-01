module Ahoy
  class Event < ActiveRecord::Base
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user
    belongs_to :action_page

    scope :actions,    -> { where(name: "Action") }
    scope :views,      -> { where(name: "View") }
    scope :emails,     -> { where("properties ->> 'actionType' = 'email'") }
    scope :congress_messages, -> { where("properties ->> 'actionType' = 'congress_message'") }
    scope :calls,      -> { where("properties ->> 'actionType' = 'call'") }
    scope :signatures, -> { where("properties ->> 'actionType' = 'signature'") }
    scope :tweets,     -> { where("properties ->> 'actionType' = 'tweet'") }
    scope :on_page,    -> (id) { where(action_page_id: id) }

    before_save :user_opt_out
    before_save :anonymize_views
    after_create :record_civicrm

    def self.group_in_range(start_date, end_date)
      zone = Time.zone.now.zone
      if (end_date - start_date) <= 5.days
        group_by_hour(
          :time,
          format: "%Y-%m-%d %H:00:00 #{zone}",
          range: start_date..end_date.tomorrow
        ).count
      else
        group_by_day(
          :time,
          format: "%Y-%m-%d 00:00:00 #{zone}",
          range: start_date..end_date.tomorrow
        ).count
      end
    end

    def user_opt_out
      if user
         user_id = nil unless user.record_activity?
      end
    end

    def record_civicrm
      if name == "Action" && user && action_page_id
        user.add_civicrm_activity! action_page_id
      end
    end

    def anonymize_views
      self.user_id = nil if name == "View"
    end
  end
end
