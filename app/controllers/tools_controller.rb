require 'rest_client'
require 'uri'
require 'json'

class ToolsController < ApplicationController
  before_filter :set_user
  before_filter :set_action_page
  before_filter :create_newsletter_subscription, only: [:call]
  after_filter :deliver_thanks_message, only: [:call, :petition, :email, :message_congress]
  skip_after_filter :deliver_thanks_message, if: :signature_has_errors
  skip_before_filter :verify_authenticity_token, only: :petition

  def call
    ahoy.track "Action",
      { type: "action", actionType: "call", actionPageId: params[:action_id] },
      action_page: @action_page

    @name = current_user.try :name

    if params[:update_user_data] == "yes"
      update_user_data(call_params.with_indifferent_access)
    end

    CallTool.campaign_call(params[:call_campaign_id],
                           phone: params[:phone],
                           location: params[:location],
                           user_id: @user.try(:id),
                           action_id: @action_page.to_param,
                           callback_url: root_url)

    render :json => {}, :status => 200
  end

  # GET /tools/social_buttons_count
  def social_buttons_count
    render status: 500
  end

  # POST /tools/petition
  #
  # A form is posted here via ajax when a user signs a petition
  def petition
    @user ||= User.find_or_initialize_by(email: params[:signature][:email])
    @email = params[:signature][:email]
    @name = params[:signature][:first_name]
    @action_page = Petition.find(params[:signature][:petition_id]).action_page
    @signature = Signature.new(signature_params.merge(user_id: @user.id))

    @signature.country_code = 'US' if @signature.zipcode.present?

    if @signature.country_code == 'US' && !Rails.application.secrets.smarty_streets_id.nil?
      if city_state = SmartyStreets.get_city_state(@signature.zipcode)
        @signature.city = city_state['city']
        @signature.state = city_state['state']
      end
    end

    if @signature.save

      # You will only get here if you are not logged in.  Subscribe does not show for logged in users,
      # since they are presented that option at signup.
      if params[:subscribe] == "1"
        @user.attributes = signature_params.slice(
          :email, :first_name, :last_name, :city, :state, :street_address,
          :zipcode, :country_code, :phone
        )

        @source = "action center petition :: " + @action_page.title
        @user.subscribe!(opt_in=true, source=@source)

      end

      if params[:partner_newsletter].present?
        Subscription.new(
          signature_params.slice(:email, :first_name, :last_name).merge(
            partner: Partner.find_by!(code: params[:partner_newsletter])
          )
        ).save
      end

      if params[:update_user_data]
        update_user_data(signature_params.with_indifferent_access)
      end

      ahoy.track "Action",
        { type: "action", actionType: "signature", actionPageId: @action_page.id },
        action_page: @action_page

      respond_to do |format|
        format.json {   render :json => {success: true}, :status => 200 }
        format.html do
          begin
            url = URI.parse(request.referer)
            url.query = [url.query.presence, 'thankyou=1'].join('&')
            redirect_to url.to_s
          rescue
            redirect_to welcome_index_path
          end
        end
      end
    else
      render :json => {errors: @signature.errors.to_json}, :status => 200
    end
  end

  def tweet
    ahoy.track "Action",
      { type: "action", actionType: "tweet", actionPageId: params[:action_id] },
      action_page: @action_page
    render :json => {success: true}, :status => 200
  end

  def email
    @user ||= User.find_or_initialize_by(email: params[:email])

    update_user_data(email_params.with_indifferent_access) if params[:update_user_data] == "true"

    ahoy.track "Action",
      { type: "action", actionType: "email", actionPageId: params[:action_id] },
      action_page: @action_page

    # You will only get here if you are not logged in.  Subscribe does not show for logged in users,
    # since they are presented that option at signup.
    if params[:subscribe] == "true"
      @user.attributes = email_params.slice(
        :first_name, :last_name, :city, :state, :street_address, :zipcode
      )

      @source = "action center email :: " + @action_page.title
      @user.subscribe!(opt_in=true, source=@source)

    end

    @name = email_params[:first_name] # for deliver_thanks_message

    render :json => {success: true}, :status => 200
  end

  def message_congress
    @user ||= User.find_or_initialize_by(email: params[:email])

    update_user_data(email_params.with_indifferent_access) if params[:update_user_data] == "true"

    ahoy.track "Action",
      { type: "action", actionType: "congress_message", actionPageId: params[:action_id] },
      action_page: @action_page

    # You will only get here if you are not logged in.  Subscribe does not show for logged in users,
    # since they are presented that option at signup.
    if params[:subscribe] == "true"
      @user.attributes = email_params.slice(
        :first_name, :last_name, :city, :state, :street_address, :zipcode
      )

      @source = "action center congress message :: " + @action_page.title
      @user.subscribe!(opt_in=true, source=@source)

    end

    @name = email_params[:first_name] # for deliver_thanks_message

    render :json => {success: true}, :status => 200
  end

  # GET /tools/email_target
  #
  # This endpoint is hit by...
  def email_target
    unless (@user and @user.events.emails.find_by_action_page_id(params[:action_id])) or params.include? :dnt
      ahoy.track "Action",
        { type: "action", actionType: "email", actionPageId: params[:action_id] },
        action_page: @action_page
    end

    if params[:service] == "copy"
      @actionPage = @action_page
    else
      redirect_to @action_page.email_campaign.service_uri(params[:service])
    end
  end

  # GET /tools/reps
  #
  # This endpoint is hit by the js for tweet actions.
  # It renders json containing html markup for presentation on the view
  def reps
    @reps = CongressMember.lookup(street: params[:street_address], zipcode: params[:zipcode])
    if @reps.present?
      update_user_data(params.slice(:street_address, :zipcode)) if params[:update_user_data] == "true"

      render :json => {content: render_to_string(partial: 'action_page/reps')}, :status => 200
    else
      render :json => {error: 'No representatives found'}, :status => 204
    end
  end

  # GET /tools/reps_raw
  #
  # This endpoint is hit by the js for email/congress message actions to lookup what legislators
  # should be emailed based on the input long/lat or zipcode
  def reps_raw
    @reps = CongressMember.lookup(street: params[:street_address], zipcode: params[:zipcode])
    if @reps.present?
      render :json => @reps, :status => 200
    else
      render :json => {error: 'No representatives found'}, :status => 204
    end
  end

  private
  def set_user
    @user = current_user
  end

  def set_action_page
    @action_page ||= ActionPage.find_by_id(params[:action_id])
  end

  def deliver_thanks_message
    @action_page ||= ActionPage.find(params[:action_id])
    @email ||= current_user.try(:email) || params[:email]
    UserMailer.thanks_message(@email, @action_page, user: @user, name: @name).deliver_now if @email
  end

  def create_newsletter_subscription
    if params[:subscription] && EmailValidator.valid?(params[:subscription][:email])
      source = "action center #{@action_page.class.name.downcase} :: " + @action_page.title
      params[:subscription][:opt_in] = true
      params[:subscription][:source] = source
      CiviCRM::subscribe params[:subscription]
    end
  end

  def signature_has_errors
    !@signature.nil? and @signature.errors.count > 0
  end

  def signature_params
    params.require(:signature).
      permit(:first_name, :last_name, :email, :petition_id, :user_id,
             :street_address, :city, :state, :country_code, :zipcode, :anonymous,
             affiliations_attributes: [:id,
                                      :institution_id,
                                      :affiliation_type_id])
  end

  def call_params
    params.permit(:phone, :zipcode, :street_address, :action_id, :call_campaign_id)
  end

  def email_params
    params.permit(:first_name, :last_name, :street_address, :city, :state, :zipcode)
  end
end
