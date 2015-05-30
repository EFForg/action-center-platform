class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  def user
    current_user = super
    current_user if current_user.try(:record_activity?)
  end

  def track_event(name, properties, options)
    action_page_id = options[:action_page_id] || options[:action_page].try(:id)
    super do |event|
      event.action_page_id = action_page_id
    end
  end
end

module Ahoy
  self.visit_duration = nil
  self.visitor_duration = nil
end
