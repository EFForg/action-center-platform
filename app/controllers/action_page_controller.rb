class ActionPageController < ApplicationController
  include ActionPageDisplay

  before_action :set_action_page,
                :protect_unpublished,
                :redirect_to_specified_url,
                :redirect_from_archived_to_active_action,
                only: %i[show show_by_institution embed_iframe
                         signature_count filter]
  before_action :redirect_to_cannonical_slug, only: [:show]
  before_action :set_institution, only: %i[show_by_institution filter]
  before_action :set_action_display_variables, only: %i[show
                                                        show_by_institution
                                                        embed_iframe
                                                        signature_count
                                                        filter]

  skip_before_action :verify_authenticity_token, only: :embed

  after_action :allow_iframe, only: :embed_iframe

  manifest :action_page

  def show
    render @actionPage.template, layout: @actionPage.layout
  end

  def index
    @actionPages = ActionPage.where(published: true, archived: false, victory: false)
                             .paginate(page: params[:page], per_page: 9)
                             .order(created_at: :desc)

    @actionPages = @actionPages.categorized(params[:category]) if params[:category].present?

    respond_to do |format|
      format.html
      format.atom
      format.json
    end
  end

  def embed
    render "action_page/embed.js.erb", layout: false
  end

  def embed_iframe
    @css = params[:css] if params.include? :css
    render layout: "application-blank"
  end

  def signature_count
    @actionPage = ActionPage.friendly.find(params[:id])

    if @actionPage.petition
      render body: @actionPage.petition.signatures.count
    else
      render body: "0"
    end
  end

  def show_by_institution
    render @actionPage.template, layout: @actionPage.layout
  end

  def filter
    redirect_to institution_action_page_url(params[:id], @institution)
  end

  private

  def set_action_page
    @actionPage = ActionPage.friendly.find(params[:id].strip)
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
    redirect_to @actionPage.redirect_url, status: 301, allow_other_host: true if @actionPage.enable_redirect
  end

  def redirect_from_archived_to_active_action
    return unless @actionPage.redirect_from_archived_to_active_action?
    return if current_user&.can_view_archived?(@actionPage)

    redirect_to @actionPage.active_action_page_for_redirect
  end

  def redirect_to_cannonical_slug
    redirect_to(@actionPage) unless request.path == action_page_path(@actionPage)
  end

  def set_institution
    @institution = Institution.friendly.find(params[:institution_id])
  end

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end
end
