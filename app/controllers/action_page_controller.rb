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
      order(created_at: :desc)

    @actionPages = @actionPages.categorized(params[:category]) if params[:category].present?

    response.headers['Cache-Control'] = 'public, no-cache'
    response.headers['Surrogate-Control'] = "max-age=120"
    response.headers['Access-Control-Allow-Origin'] = "*"
    respond_to do |format|
      format.html
      format.atom
      format.json
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
      if current_user.try(:admin?) || current_user.try(:collaborator?)
        flash.now[:notice] = "This page is not published. Only Admins and Collaborators can view it."
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
        redirect_to @actionPage.active_action_page_for_redirect
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
    @congress_message_campaign = @actionPage.congress_message_campaign

    # Shows a mailing list if no tools enabled
    @no_tools = [:tweet, :petition, :call, :email, :congress_message].none? do |tool|
      @actionPage.send "enable_#{tool}".to_sym
    end

    set_signatures

    if @actionPage.petition and @actionPage.petition.enable_affiliations
      @top_institutions = @actionPage.institutions.top(300, first: @institution.try(:id))
      @institutions = @actionPage.institutions.order(:name)
    end

    @topic_category = nil
    if @email_campaign and not @email_campaign.topic_category.nil?
      @topic_category = @email_campaign.topic_category.as_2d_array
    end
    if @congress_message_campaign.try(:topic_category).present?
      @topic_category = @congress_message_campaign.topic_category.as_2d_array
    end

    # Initialize a temporary signature object for form auto-population
    current_zipcode = params[:zipcode] || current_user.try(:zipcode)
    @signature = Signature.new(petition_id: @actionPage.petition_id)
    @signature.attributes = { first_name: current_first_name,
                              last_name: current_last_name,
                              street_address: current_street_address,
                              state: current_state,
                              city: current_city,
                              zipcode: current_zipcode,
                              country_code: current_country_code,
                              email: current_email }

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
