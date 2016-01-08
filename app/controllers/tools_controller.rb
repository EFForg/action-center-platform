require 'smarty_streets'
require 'rest_client'
require 'uri'
require 'json'
class ToolsController < ApplicationController
  before_filter :set_user
  before_filter :set_action_page
  after_filter :deliver_thanks_message, only: [:call, :petition, :email]
  skip_after_filter :deliver_thanks_message, if: :signature_has_errors
  skip_before_filter :verify_authenticity_token, only: :petition

  def call_required_fields
    response = RestClient.get Rails.application.config.call_tool_url +
      '/api/campaign/' + params[:call_campaign_id] +
      '?api_key=' + Rails.application.secrets.call_tool_api_key
    render :json => JSON.parse(response.body)["required_fields"]
  end

  def call
    ahoy.track "Action",
      { type: "action", actionType: "call", actionPageId: params[:action_id] },
      action_page: @action_page

    @name = current_user.try :name

    if params[:update_user_data] == "yes"
      update_user_data(call_params.with_indifferent_access)
    end

    begin
      response = RestClient.get Rails.application.config.call_tool_url + '/call/create',
        params: { campaignId: params[:call_campaign_id],
                  userPhone:  params[:phone],
                  userCountry: 'US',
                  userLocation: params[:location],
                  # TODO - Settle on the schema of the private meta data
                  meta: {
                    user_id:     @user.try(:id),
                    action_id:   params[:action_id],
                    action_type: 'call'
                  }.to_json,
                  callback_url: root_url }
    rescue RestClient::BadRequest => e
      begin
        error = JSON.parse(e.http_body)["error"]
      rescue
        raise e
      end
      # Don't raise for twilio error 13224: number invalid
      unless error.match(/^13224:/)
        if Rails.application.secrets.sentry_dsn.nil?
          raise error
        else
          Raven.capture_message(error, { :level => 'info' })
        end
      end
    end

    render :json => {}, :status => 200
  end

  # get /tools/social_buttons_count
  def social_buttons_count
    render(:json => {"googleplus" => 0,"facebook" => 0}, :status => 200) and return if Rails.env == 'test'

    sbResponse = RestClient.get 'https://socialbuttonsserver.herokuapp.com/',
      {:params => {:url => params[:url], :networks => 'facebook,twitter,googleplus'}}

    request.session_options[:skip] = true  # removes session data
    response.headers['Cache-Control'] = 'public, no-cache'
    response.headers['Surrogate-Control'] = "max-age=300"

    render :json => sbResponse, :status => 200
  end

  # An HTML view ajax posts a form when a user signs a petition
  # POST /tools/petition
  def petition
    @user ||= User.find_or_initialize_by(email: params[:signature][:email])
    @email = params[:signature][:email]
    @name = params[:signature][:first_name]
    @action_page = Petition.find(params[:signature][:petition_id]).action_page
    @signature = Signature.new(signature_params.merge(user_id: @user.id))

    @signature.country_code = 'US' unless @signature.country_code.present?

    if @signature.country_code == 'US' && @signature.zipcode.present? && @signature.city.blank? && @signature.state.blank? && !Rails.application.secrets.smarty_streets_id.nil?
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
        @user.subscribe!(opt_in=false, source=@source)

      end

      if params[:partner_newsletter].present?
        Subscription.new(
          signature_params.slice(:email, :first_name, :last_name).merge(
            partner: Partner.find_or_create_by(code: params[:partner_newsletter])
          )
        ).save
      end

      if params[:update_user_data]
        update_user_data(signature_params.with_indifferent_access)
      end

      ahoy.track "Action",
        { type: "action", actionType: "signature", actionPageId: @action_page.id },
        action_page: @action_page

      update_congress_scorecards(signature_params[:zipcode])

      respond_to do |format|
        format.json {   render :json => {success: true}, :status => 200 }
        format.html do
          flash[:notice] = 'You successfully signed the petition'
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

    if params[:update_user_data] == "true"
      update_user_data(email_params.with_indifferent_access)
    end

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
      @user.subscribe!(opt_in=false, source=@source)

    end

    update_congress_scorecards(email_params[:zipcode])

    @name = email_params[:first_name] # for deliver_thanks_message

    render :json => {success: true}, :status => 200
  end

  def email_target
    unless (@user and @user.events.emails.find_by_action_page_id(params[:action_id])) or params.include? :dnt
      ahoy.track "Action",
        { type: "action", actionType: "email", actionPageId: params[:action_id] },
        action_page: @action_page
    end
    subject_uri = URI::escape @action_page.email_campaign.subject
    subject_cgi = CGI::escape @action_page.email_campaign.subject
    body_uri = URI::escape @action_page.email_campaign.message
    body_cgi = CGI::escape @action_page.email_campaign.message
    body_hotmail = CGI::escape @action_page.email_campaign.message.gsub("\r\n","<br>")
    to_cgi = CGI::escape @action_page.email_campaign.email_addresses.gsub(" ","")
    case params[:service]
    when "default"
      redirect_to "mailto:" + to_cgi + "?subject=" + subject_uri + "&body=" + body_uri
    when "gmail"
      redirect_to "https://mail.google.com/mail/?view=cm&fs=1&to=" + to_cgi + "&su=" + subject_cgi + "&body=" + body_cgi
    when "yahoo"
      # couldn't get newlines to work here, see: https://stackoverflow.com/questions/1632335/uri-encoding-in-yahoo-mail-compose-link
      redirect_to "http://compose.mail.yahoo.com/?to=" + to_cgi + "&subj=" + subject_cgi + "&body=" + body_cgi
    when "hotmail"
      redirect_to "https://mail.live.com/default.aspx?rru=compose&to=" + to_cgi + "&subject=" + subject_cgi + "&body=" + body_hotmail
    when "copy"
      @actionPage = @action_page
      render
    end
  end

  def reps
    if params[:zipcode]
      @reps = Sunlight::Congress::Legislator.by_zipcode(params[:zipcode])
    elsif params[:lat] && params[:lon]
      @reps = Sunlight::Congress::Legislator.by_latlong(params[:lat], params[:lon])
    end

    if @reps.present?
      if params[:update_user_data] == "true"
        update_user_data(params.slice(:street_address, :zipcode))
      end

      render :json => {content: render_to_string(partial: 'action_page/reps')}, :status => 200
    else
      render :json => {error: 'No representatives found'}, :status => 204
    end
  end

  # Todo - Shouldn't clone the above method but have to refactor that partial
  # to return json and then render on client

  def reps_raw
    if params[:zipcode]
      @reps = Sunlight::Congress::Legislator.by_zipcode(params[:zipcode])
    elsif params[:lat] && params[:lon]
      @reps = Sunlight::Congress::Legislator.by_latlong(params[:lat], params[:lon])
    end
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
    UserMailer.thanks_message(@email, @action_page, user: @user, name: @name).deliver if @email
  end

  # This makes a 3rd party lookup to Sunlight API to get all the representatives
  # relevant to a zipcode and add a tally to their CongressScorecard (creating it if needed)
  def update_congress_scorecards(zipcode)
    return unless GoingPostal.valid_zipcode?(zipcode, 'US')
    Sunlight::Congress::Legislator.by_zipcode(zipcode).each do |rep|
      CongressScorecard.find_or_create_by(
        bioguide_id: rep.bioguide_id,
        action_page_id: @action_page.id
      ).increment!
    end
  end

  def signature_has_errors
    !@signature.nil? and @signature.errors.count > 0
  end

  def signature_params
    params.require(:signature).
      permit(:first_name, :last_name, :email, :petition_id, :user_id,
             :street_address, :city, :state, :country_code, :zipcode, :anonymous)
  end

  def call_params
    params.permit(:phone, :zipcode, :street_address, :action_id, :call_campaign_id)
  end

  def email_params
    params.permit(:first_name, :last_name, :street_address, :city, :state, :zipcode)
  end
end
