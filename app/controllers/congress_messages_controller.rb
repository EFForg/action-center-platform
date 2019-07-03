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
    @message = CongressMessage.new_from_lookup(location, params[:message], @campaign, forms)
    render partial: "form"
  end

  def create
    @message = CongressMessage.new(congress_message_params)
    @message.forms = CongressForms::Form.find(params["bioguide_ids"])
    if @message.submit
      @actionPage = @campaign.action_page
      render partial: "tools/share"
    else
      render plain: I18n.t(:submission_failed, scope: :congress_forms), status: :bad_request
    end
  end

  private

  def set_congress_message_campaign
    @campaign = CongressMessageCampaign.find(params["congress_message_campaign_id"])
  end

  def congress_message_params
    # In Rails 5.1 we can do params.permit(common_attributes: {}, member_attributes: {})
    params.permit.tap do |p|
      p[:common_attributes] = params[:common_attributes].permit!
      p[:member_attributes] = params[:member_attributes].permit!
    end
  end
end
