class CongressMessagesController < ApplicationController
  include Tooling

  before_action :set_congress_message_campaign
  before_action :update_user, only: :create

  # See https://github.com/EFForg/action-center-platform/wiki/Deployment-Notes#csrf-protection
  skip_before_action :verify_authenticity_token, only: :create
  before_action :verify_request_origin, only: :create

  rescue_from SmartyStreets::AddressNotFound, with: :address_not_found
  rescue_from CongressForms::RequestFailed, with: :congress_forms_request_failed

  def new
    if @campaign.target_bioguide_ids.present?
      bioguide_ids = @campaign.target_bioguide_ids.split(",")
      @members = CongressMember.where(bioguide_id: bioguide_ids)
    else
      location = SmartyStreets.get_location(params[:street_address], params[:zipcode])
      @members = @campaign.targets.for_district(location.state, location.district)
      bioguide_ids = @members.pluck(:bioguide_id)
    end
    forms, @links = CongressForms::Form.find(bioguide_ids)
    @defunct_members, @members = @members.partition do |m|
      @links.keys.include? m.bioguide_id
    end
    @message = CongressMessage.new_from_lookup(location, @campaign, forms)
    render partial: "form"
  end

  def create
    @message = CongressMessage.new(congress_message_params.merge(campaign: @campaign))
    # Custom messages are set after other fields and need to be refreshed
    @message.update_common_attributes("$MESSAGE": params[:message])
    bioguide_ids = if params.key? :bioguide_id
                     [params[:bioguide_id]]
                   else
                     params[:forms][:bioguide_ids]
                   end
    @message.forms, _ = CongressForms::Form.find(bioguide_ids)

    if EmailValidator.valid?(user_params[:email]) && @message.background_submit(params[:test])
      @name = user_params[:first_name] # for deliver_thanks_message
      @email = user_params[:email] # for deliver_thanks_message
      track_action unless params[:test]
      deliver_thanks_message unless subscribe_user
      render partial: "tools/share"
    else
      render plain: I18n.t(:invalid_submission, scope: :congress_forms), status: :bad_request
    end
  end

  private

  def set_congress_message_campaign
    @campaign = CongressMessageCampaign.find(params[:congress_message_campaign_id])
    @actionPage = @campaign.action_page
    @action_page = @actionPage # Account for inconsistent naming in views.
  end

  def congress_message_params
    # In Rails 5.1 we can do params.permit(common_attributes: {}, member_attributes: {})
    params.permit.tap do |p|
      p[:common_attributes] = params[:common_attributes] && params[:common_attributes].permit!
      p[:member_attributes] = params[:member_attributes] && params[:member_attributes].permit!
    end
  end

  def user_params
    params.require(:common_attributes).permit.tap do |p|
      common = params[:common_attributes]
      p[:first_name] = common["$NAME_FIRST"]
      p[:last_name] = common["$NAME_LAST"]
      p[:city] = common["$ADDRESS_CITY"]
      p[:state] = common["$ADDRESS_STATE"]
      p[:street_address] = common["$ADDRESS_STREET"]
      p[:zipcode] = common["$ADDRESS_ZIP5"]
      p[:email] = common["$EMAIL"]
    end
  end

  def partner_signup_params
    user_params.permit(:first_name, :last_name, :email)
  end

  def update_user
    if params[:update_user_data] == "yes"
      current_user.update(user_params.except(:email))
    end
  end

  def subscribe_user
    create_partner_subscription

    if params[:subscribe] == "1"
      source = "action center congress message :: " + @action_page.title
      user = User.find_or_initialize_by(email: user_params[:email])
      user.attributes = user_params
      user.subscribe!(opt_in = false, source = source)["requires_confirmation"]
    end
  end

  def track_action
    customized_message = params[:message] != @campaign.message
    ahoy.track "Action",
      { type: "action", actionType: "congress_message", actionPageId: params[:action_id],
        customizedMessage: customized_message },
      action_page: @action_page
  end

  def address_not_found
    render plain: I18n.t(:address_lookup_failed, scope: :congress_forms), status: :bad_request
  end

  def congress_forms_request_failed
    render plain: I18n.t(:request_failed, scope: :congress_forms), status: :internal_server_error
  end
end
