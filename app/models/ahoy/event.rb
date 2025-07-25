module Ahoy
  class Event < ApplicationRecord
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user
    belongs_to :action_page
    counter_culture :action_page, column_name: proc { |record|
      case record.name
      when "Action"
        "action_count"
      when "View"
        "view_count"
      end
    }

    scope :actions,    -> { where(name: "Action") }
    scope :views,      -> { where(name: "View") }
    scope :emails,     -> { where("properties ->> 'actionType' = 'email'") }
    scope :congress_messages, -> { where("properties ->> 'actionType' = 'congress_message'") }
    scope :calls,      -> { where("properties ->> 'actionType' = 'call'") }
    scope :signatures, -> { where("properties ->> 'actionType' = 'signature'") }
    scope :tweets,     -> { where("properties ->> 'actionType' = 'tweet'") }
    scope :on_page,    ->(id) { where(action_page_id: id) }
    scope :in_range, lambda { |start_date, end_date|
      where(time: start_date..end_date.tomorrow)
    }

    after_create :record_civicrm

    TYPES = %i[views emails tweets calls signatures congress_messages].freeze

    def self.action_types(action_page = nil)
      TYPES.dup.tap do |t|
        if action_page.present?
          t.delete(:calls) unless action_page.enable_call
          t.delete(:congress_messages) unless action_page.enable_congress_message
          t.delete(:emails) unless action_page.enable_email
          t.delete(:signatures) unless action_page.enable_petition
          t.delete(:tweets) unless action_page.enable_tweet
        end
      end
    end

    # Formats the event data for a chart
    def self.chart_data(type: nil, range: nil)
      by_type = TYPES.include? type.try(:to_sym)
      collection = by_type ? all.send(type) : group(:name)
      collection.group_by_day(
        :time,
        format: "%b %-e %Y",
        range: range,
        default_value: 0
      ).count
    end

    # Reformats chart data for use in tables
    # Returns the following format:
    # {
    #   "June 1 2019": {
    #     action: 10,
    #     view: 20
    #   },
    #   ...
    # }
    def self.table_data
      {}.tap do |table|
        chart_data.each do |(type, date), count|
          table[date] ||= {}
          key = type.downcase.to_sym
          table[date][key] = count
        end
      end
    end

    # Returns events grouped by date. Can be used to chart event collections
    # with only one event type
    def self.group_by_date
      group_by_day
    end

    def self.summary
      { view: views.count, action: actions.count }
    end

    def record_civicrm
      return unless name == "Action" && user && action_page_id
      user.add_civicrm_activity! action_page_id
    end
  end
end
