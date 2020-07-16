require "rest_client"
module CiviCRM
  module UserMethods
    def contact_attributes
      attributes.symbolize_keys.slice(
        :email, :first_name, :last_name, :city, :state, :street_address,
        :zipcode, :country_code, :phone
      )
    end

    def subscribe!(opt_in = false, source = "action center")
      return nil if CiviCRM.skip_crm?
      res = CiviCRM::subscribe contact_attributes.merge(opt_in: opt_in, source: source)
      update_attributes(contact_id: res["contact_id"]) if (res && res["contact_id"])
      res || {}
    end

    def contact_id!
      return nil if CiviCRM.skip_crm?
      res = CiviCRM::import_contact contact_attributes
      update_attributes(contact_id: res["contact_id"]) if (res && res["contact_id"])
      contact_id
    end

    def add_civicrm_activity!(action_page_id)
      return nil if CiviCRM.skip_crm?
      if contact_id && action_page = ActionPage.find_by_id(action_page_id)
        CiviCRM::add_activity(
          contact_id: contact_id,
          subject: "Took Action #{action_page.id}: #{action_page.title}"
        )
      end
    end

    def manage_subscription_url!
      checksum = CiviCRM::get_checksum(contact_id)
      return nil unless checksum
      "#{Rails.application.secrets.supporters['host']}/update-your-preferences?" + {
        cid1: contact_id,
        cs: checksum
      }.to_param
    end
  end

  def self.skip_crm?
    Rails.application.secrets.supporters["api_key"].nil?
  end

  def self.subscribe(params)
    return {} if skip_crm?
    self.import_contact params.merge(subscribe: true)
  end

  def self.import_contact(params)
    return {} if skip_crm?
    post base_params.merge(
      method: "import_contact",
      data: {
        contact_params: params.slice(:email, :first_name, :last_name).merge(
          source: params[:source] || "action center",
          subscribe: params[:subscribe],
          opt_in: params[:opt_in]
        ),
        address_params: params.slice(:city, :state).merge(
          street: params[:street_address],
          zip: params[:zipcode],
          country: params[:country_code]
        ),
        phone: params[:phone]
      }.to_json
    )
  end

  def self.add_activity(params)
    return nil if skip_crm?
    post base_params.merge(
      method: "add_activity",
      data: params.slice(:contact_id, :subject, :activity_type_id).to_json
    )
  end

  def self.supporters_api_url
    "#{Rails.application.secrets.supporters['host']}/#{Rails.application.secrets.supporters['path']}"
  end

  private

  def self.post(params)
    begin
      res = JSON.parse RestClient.post(supporters_api_url, params)
      raise res["error_message"] if res["error"]
      return res
    rescue => e
      Raven.capture_exception(e)
      Rails.logger.error "#{ e } (#{ e.class })!"
      return false
    end
  end

  def self.send_email_template_data(params)
    base_params.merge(
      method: "send_email_template",
      data: params.slice(:contact_id,
                         :message_template_id,
                         :template_data,
                         :from).to_json
    )
  end

  def self.find_contact_by_email_data(params)
    base_params.merge(
      method: "find_contact_by_email",
      data: params.slice(:email).merge(method: "find_contact_by_email").to_json
    )
  end

  def self.get_checksum(contact_id)
    return nil if skip_crm?
    # Valid for 24 hours
    res = post base_params.merge(
      method: "generate_checksum",
      data: contact_id
    )
    res && res["checksum"]
  end

  def self.base_params
    { site_key: Rails.application.secrets.supporters["api_key"] }
  end
end
