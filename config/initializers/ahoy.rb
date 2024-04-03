class Ahoy::Store < Ahoy::DatabaseStore
  def autheticate(data)
    # Documentation says to make this method blank to disable automatic
    # linking of visits and users
  end

  def user
    current_user = super
    current_user if current_user.try(:record_activity?)
  end

  def track_event(data)
    # TODO: this will probably break because it's getting a data hash not these
    # individual variables...
    # can get request info via request.parameters
    action_page_id = data[:action_page_id] || data[:action_page].try(:id)
    data[:id] = ensure_uuid(data.delete(:event_id))
    super(data)
  end

  # Based on https://github.com/ankane/ahoy/blob/ee2d0b3afff6284f57e372926d4a82fc91c8a948/docs/Ahoy-2-Upgrade.md#activerecordstore
  # TODO: find better uuid?
  def track_visit(data)
    data[:id] = ensure_uuid(data.delete(:visit_token))
    data[:visitor_id] = ensure_uuid(data.delete(:visitor_token))
    super(data)
  end

  def visit
    @visit ||= visit_model.find_by(id: ensure_uuid(ahoy.visit_token)) if ahoy.visit_token
  end

  def visit_model
    Visit
  end

  UUID_NAMESPACE = UUIDTools::UUID.parse("a82ae811-5011-45ab-a728-569df7499c5f")

  def ensure_uuid(id)
    UUIDTools::UUID.parse(id).to_s
  rescue
    UUIDTools::UUID.sha1_create(UUID_NAMESPACE, id).to_s
  end
end

module Ahoy
  self.visit_duration = nil
  self.visitor_duration = nil
  self.api = true
  self.server_side_visits = false
  self.mask_ips = true
  self.cookies = false
end
