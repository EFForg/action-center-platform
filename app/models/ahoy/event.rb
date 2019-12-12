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

    TYPES = %i(views emails tweets calls signatures congress_messages).freeze

    def self.action_types(action_page = nil)
      TYPES.dup.tap do |t|
        if action_page.present?
          t.delete(:calls) if !action_page.enable_call
          t.delete(:congress_messages) if !action_page.enable_congress_message
          t.delete(:emails) if !action_page.enable_email
          t.delete(:signatures) if !action_page.enable_petition
          t.delete(:tweets) if !action_page.enable_tweet
        end
      end
    end

    # Returns a hash with the following format:
    # {
    #   "June 1": {
    #     "views": 10
    #     "signatures": 5
    #   }
    # }
    def self.group_by_type_in_range(start_date, end_date)
      group("properties ->> 'actionType'").group_in_range(start_date, end_date).reduce({}) do |r, row|
        pair, count = row
        action, date = pair
        r[date] = {} unless r[date]
        action = "view" if action == "embedded_view" || action == "show"
        if action.present?
          action = action.pluralize.to_sym
          r[date][action] = 0 unless r[date][action]
          r[date][action] += count
        end
        r
      end
    end

    def self.counts_by_date(start_date, end_date)
      result = group(:name).group_by_day(:time, format: "%b %-e %Y",
                                                range: start_date..end_date.tomorrow)
                           .count
      result.reduce({}) do |h, row|
        pair, count = row
        type, date = pair
        h[date] ||= {}
        if type.present?
          type = type.downcase.to_sym
          h[date][type] ||= 0
          h[date][type] += count
        end
        h
      end
    end

    def self.group_in_range(start_date, end_date)
      if (end_date - start_date) <= 5.days
        group_by_hour(
          :time,
          format: "%b %-e, %-l%P",
          range: start_date..end_date.tomorrow
        ).count
      else
        group_by_day(
          :time,
          format: "%b %-e %Y",
          range: start_date..end_date.tomorrow
        ).count
      end
    end

    def self.summary(start_date, end_date)
      events = where(time: start_date..(end_date + 1.day))
      view_count = events.views.count
      action_count = events.actions.count
      { 
        view: view_count, action: action_count
      }
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
