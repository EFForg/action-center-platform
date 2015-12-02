require 'rest_client'
module CiviCRM
  module UserMethods
    def contact_attributes
      attributes.with_indifferent_access.slice(
        :email, :first_name, :last_name, :city, :state, :street_address,
        :zipcode, :country_code, :phone
      )
    end

    def subscribe!(opt_in=false, source='action center')
      res = CiviCRM::subscribe contact_attributes.merge(opt_in: opt_in, source: source)
      update_attributes(contact_id: res['contact_id']) if (res && res['contact_id'])
    end

    def contact_id!
      res = CiviCRM::import_contact contact_attributes
      update_attributes(contact_id: res['contact_id']) if (res && res['contact_id'])
      contact_id
    end

    def add_civicrm_activity!(action_page_id)
      if contact_id && action_page = ActionPage.find_by_id(action_page_id)
        CiviCRM::add_activity(
          contact_id: contact_id,
          subject: "Took Action #{action_page.id}: #{action_page.title}"
        )
      end
    end
  end

  def self.subscribe(params)
    self.import_contact params.merge(subscribe: true)
  end

  def self.import_contact(params)
    post base_params.merge(
      method: 'import_contact',
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
    post base_params.merge(
      method: 'add_activity',
      data: params.slice(:contact_id, :subject, :activity_type_id).to_json
    )
  end

  private
  def self.post(params)
    begin
      res = JSON.parse RestClient.post(SUPPORTERS_API_URL, params)
      raise res['error_message'] if res['error']
      return res
    rescue => e
      puts "#{ e } (#{ e.class })!"
    end
  end

  def self.send_email_template_data(params)
    base_params.merge(
      method: 'send_email_template',
      data: params.slice(:contact_id,
                         :message_template_id,
                         :template_data,
                         :from).to_json
    )
  end

  def self.find_contact_by_email_data(params)
    base_params.merge(
      method: 'find_contact_by_email',
      data: params.slice(:email).merge(method: 'find_contact_by_email').to_json
    )
  end

  def self.base_params
    { site_key: ENV['supporters_api_key'] }
  end
end
