class CongressMessagesController < ApplicationController
  def new
    location = SmartyStreets.get_location(params["street_address"], params["zipcode"])
    unless location.success
      render plain: I18n.t(:address_lookup_failed, scope: :congress_forms), status: :bad_request
      return
    end
    @message_attributes = message_attributes(location, params["message"])
    @campaign = CongressMessageCampaign.find(params["congress_message_campaign_id"])

    members = CongressMember.for_district(location.state, location.district)
    if members.empty?
      # Notify Sentry?
      render plain: I18n.t(:reps_lookup_failed, scope: :congress_forms), status: :bad_request
      return
    end
    @forms = CongressForms::Form.find(members.pluck(:bioguide_id))
    @common = CongressForms::Form.common_fields(@forms)
    # Data prep
    #  - Sort all groups
    render partial: "form"
  end

  def create
    # @TODO avoid repeating this request?
    forms = CongressForms::Form.find(params[bioguide_ids])
    forms.each do |f|
      unless f.validate(params)
        # Re-render form and return
      end
    end
    forms.each do |f|
      unless f.submit(params)
        # re-render form and return
      end
    end
  end

  # @TODO move to lib/congress_forms.rb?
  # @TODO no longer need to CSS hide these fields
  def message_attributes(location, message)
    {
      "$ADDRESS_STREET" => location.street,
      "$ADDRESS_CITY" => location.city,
      "$ADDRESS_ZIP4" => location.zip4,
      "$ADDRESS_ZIP5" => location.zipcode,
      # @TODO abbreviation expected here? what forms can the state field take?
      "$STATE" => location.state,
      "$MESSAGE" => message
    }
  end
end
