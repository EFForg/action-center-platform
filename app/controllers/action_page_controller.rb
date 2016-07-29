class ActionPageController < ApplicationController
  before_filter :set_institution, only: [:show_by_institution, :filter]
  before_filter :set_action_display_variables, only: [:show, :show_by_institution, :embed_iframe, :signature_count]
  skip_before_filter :verify_authenticity_token, only: :embed
  after_action :allow_iframe, only: :embed_iframe

  manifest :action_page

  def show
    render @actionPage.template, layout: @actionPage.layout
  end

  def index
    @actionPages = ActionPage.where(published: true, archived: false, victory: false).
      paginate(:page => params[:page], :per_page => 9).
      order('id desc')

    #request.session_options[:skip] = true  # removes session data
    response.headers['Cache-Control'] = 'public, no-cache'
    response.headers['Surrogate-Control'] = "max-age=120"
    response.headers['Access-Control-Allow-Origin'] = "*"
    respond_to do |format|
      format.html
      format.atom
    end
  end

  def embed
    render layout: false, template: "action_page/embed.js.erb"
  end

  def embed_iframe
    if params.include? :css
      @css = params[:css]
    end

    render layout: 'application-blank'
  end

  def signature_count
    send_cache_disablement_headers
    response.headers['Access-Control-Allow-Origin'] = "*"
    @actionPage = ActionPage.friendly.find(params[:id])

    if petition = @actionPage.petition
      render text: petition.signatures.count
    else
      render text: '0'
    end
  end

  def show_by_institution
    respond_to do |format|
      format.csv { send_data @petition.to_affiliation_csv(@institution) }
      format.html { render @actionPage.template, layout: @actionPage.layout }
    end
  end

  def filter
    redirect_to institution_action_page_url(params[:id], @institution)
  end

private
  def set_action_display_variables
    @actionPage = ActionPage.friendly.find(params[:id])
    if @actionPage.enable_redirect
        redirect_to @actionPage.redirect_url, :status => 301
      return
    end

    # Redirect visitors to archived actions unless they have taken that action.
    if @actionPage.archived? and @actionPage.archived_redirect_action_page_id and !@actionPage.victory?
      taken_action = false
      unless current_user.nil?
        taken_action = true if current_user.events.actions.where(action_page_id: @actionPage).first
      end
      return redirect_to(action_page_path(@actionPage.archived_redirect_action_page_id)) unless taken_action || current_user.try(:admin?)
    end

    unless @actionPage.published?
      if current_user.try(:admin?)
        flash.now[:notice] = "This page is not published. Only Admins can view it."
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    if params[:action] == "show"
      # Redirect to canonical url if necessary
      return redirect_to(@actionPage) unless request.path == action_page_path(@actionPage)
    end

    @title = @actionPage.title
    @petition = @actionPage.petition
    @tweet = @actionPage.tweet
    @email_campaign = @actionPage.email_campaign
    if params[:zipcode]
      current_zipcode = params[:zipcode]
    end
    if current_user && current_user.zipcode
      current_zipcode = current_user.zipcode
    end
    if (@tweet.try(:target_house) || @tweet.try(:target_senate)) && current_zipcode
      @reps = Sunlight::Congress::Legislator.by_zipcode(current_zipcode)
    end

    # Shows a mailing list if no tools enabled
    @no_tools = [:tweet, :petition, :call, :email].none? do |tool|
      @actionPage.send "enable_#{tool}".to_sym
    end

    set_signatures

    @institutions = @actionPage.institutions.order(:name)

    @topic_category = nil
    if @email_campaign and not @email_campaign.topic_category.nil?
      @topic_category = @email_campaign.topic_category.as_2d_array
    end

    # Initialize a temporary signature object for form auto-population
    @signature = Signature.new(petition_id: @actionPage.petition_id)
    @signature.attributes = { first_name: current_first_name,
                              last_name: current_last_name,
                              street_address: current_street_address,
                              state: current_state,
                              city: current_city,
                              zipcode: current_zipcode,
                              country_code: current_country_code,
                              email: current_email }
    if @actionPage.petition and @actionPage.petition.enable_affiliations
      @signature.affiliations.build
    end

    # Tracking
    if params[:action] == "show"
      @action_type = "view"
    else
      @action_type = "embedded_view"
    end

    ahoy.track "View",
      { type: "action", actionType: @action_type, actionPageId: @actionPage.id },
      action_page: @actionPage

    #request.session_options[:skip] = true  # removes session data
    #response.headers.delete 'Set-Cookie'
    response.headers['Cache-Control'] = 'public, no-cache'
    response.headers['Surrogate-Control'] = "max-age=120"
  end

  def set_signatures
    if @petition
      if @institution
        @signatures = @petition.signatures_by_institution(@institution)
          .paginate(:page => params[:page], :per_page => 9).order(created_at: :desc)
        @institution_signature_count = @signatures.pretty_count
      elsif @petition.enable_affiliations
        @signatures = @petition.signatures.paginate(:page => params[:page], :per_page => 9).order(created_at: :desc)
      else
        @signatures = @petition.signatures.order(created_at: :desc).limit(5)
      end
      @signature_count = @petition.signatures.pretty_count
      @require_location = !@petition.enable_affiliations
    end
  end

  def set_institution
    @institution = Institution.friendly.find(params[:institution_id])
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
