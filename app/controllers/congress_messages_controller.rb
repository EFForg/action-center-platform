class CongressMessagesController < ApplicationController
  before_action :set_congress_message_campaign

  def new
    location = SmartyStreets.get_location(params["street_address"], params["zipcode"])
    unless location.success
      render plain: I18n.t(:address_lookup_failed, scope: :congress_forms), status: :bad_request
      return
    end

    members = CongressMember.for_district(location.state, location.district)
    if members.empty?
      # Notify Sentry?
      render plain: I18n.t(:reps_lookup_failed, scope: :congress_forms), status: :bad_request
      return
    end

    forms = CongressForms::Form.find(members.pluck(:bioguide_id))
    @message = CongressMessage.new_from_lookup(location, params[:message], forms)
    render partial: "form"
  end

  def create
    @message = CongressMessage.new({ inputs: params })
    @message.forms = CongressForms::Form.find(params[bioguide_ids])
    if @message.submit
      # success!
    else
      # boo
    end
  end

  private

  def set_congress_message_campaign
    @campaign = CongressMessageCampaign.find(params["congress_message_campaign_id"])
  end
end
