module Admin
  module EventsHelper
    def humanize_event_type(type)
      case type
      when :views
        "Action Page Views"
      when :emails
        "Email Actions"
      when :congress_messages
        "Congress Message Actions"
      else
        type.to_s.humanize.capitalize
      end
    end
  end
end
