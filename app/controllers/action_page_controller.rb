class ActionPageController < ApplicationController
  before_filter :set_action_page,
                :protect_unpublished,
                :redirect_to_specified_url,
                :redirect_from_archived_to_active_action,
                only: [:show, :show_by_institution, :embed_iframe, :signature_count]
  before_filter :redirect_to_cannonical_slug, only: [:show]
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
  def set_action_page
    @actionPage = ActionPage.friendly.find(params[:id])
  end

  def protect_unpublished
    unless @actionPage.published?
      if current_user.try(:admin?)
        flash.now[:notice] = "This page is not published. Only Admins can view it."
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  def redirect_to_specified_url
    if @actionPage.enable_redirect
      redirect_to @actionPage.redirect_url, :status => 301
    end
  end

  def redirect_from_archived_to_active_action
    if @actionPage.redirect_from_archived_to_active_action?
      # Users can access actions they've taken in the past as a historical record
      unless current_user and (current_user.taken_action? @actionPage or current_user.admin?)
        redirect_to @actionPage.redirect_target_action_if_archived
      end
    end
  end

  def redirect_to_cannonical_slug
    redirect_to(@actionPage) unless request.path == action_page_path(@actionPage)
  end

  def set_action_display_variables

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

    if @actionPage.petition and @actionPage.petition.enable_affiliations
      # Sort institutions by most popular.
      # Put the selected institution at the top of the list if it exists.
      institution_id = @institution ? @institution.id : 0
      @top_institutions = @actionPage.institutions.select("institutions.*, COUNT(signatures.id) AS s_count")
          .joins("LEFT OUTER JOIN affiliations ON institutions.id = affiliations.institution_id")
          .joins("LEFT OUTER JOIN signatures ON affiliations.signature_id = signatures.id")
          .group("institutions.id")
          .order("institutions.id = #{institution_id} desc", "s_count DESC", "institutions.name")
          .limit(300)
      @institutions = @actionPage.institutions.order(:name)
    end

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

      # Signatures filtered by institution
      if @institution
        @signatures = @petition.signatures_by_institution(@institution)
            .paginate(:page => params[:page], :per_page => 9)
            .order(created_at: :desc)
        @institution_signature_count = @signatures.pretty_count

      # Signatures with associated affiliations
      elsif @petition.enable_affiliations
        @signatures = @petition.signatures
            .includes(:affiliations => [:institution, :affiliation_type])
            .paginate(:page => params[:page], :per_page => 9)
            .order(created_at: :desc)

      # Signatures, no affiliations
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
