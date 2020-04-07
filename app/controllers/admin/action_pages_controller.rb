class Admin::ActionPagesController < Admin::ApplicationController
  include DateRange
  include ActionPageDisplay

  before_action :set_action_page, only: [
    :edit,
    :update,
    :destroy,
    :events,
    :events_table,
    :duplicate,
    :preview,
    :status,
    :edit_partners
  ]

  before_action :set_petition_targets, only: %i(new edit duplicate)
  before_action :set_partners, only: %i(new edit duplicate)
  before_action :set_source_files, only: %i(new edit create update duplicate)

  after_action :purge_cache, only: [:update, :publish]

  allow_collaborators_to :index, :edit

  def index
    @categories = Category.all.order(:title)
    @authors = User.authors.order(:last_name)
    @actionPages = filter_action_pages

    if request.xhr?
      render partial: "admin/action_pages/index"
    end
  end

  def new
    @actionPage = ActionPage.new
    @actionPage.petition = Petition.new
    @actionPage.tweet = Tweet.new
    @actionPage.call_campaign = CallCampaign.new
    @actionPage.email_campaign = EmailCampaign.new
    @actionPage.congress_message_campaign = CongressMessageCampaign.new
    @actionPage.email_text = Rails.application.config.action_pages_email_text
    10.times { @actionPage.affiliation_types.build }
  end

  def create
    @actionPage = ActionPage.new(action_page_params.merge(author: current_user))

    if @actionPage.save
      if institutions_params[:category]
        ActionInstitution.add(action_page: @actionPage,
                              category: institutions_params[:category])
      end
      redirect_to action_page_path(@actionPage)
    else
      render "new"
    end
  end

  def edit
    @actionPage.petition ||= Petition.new
    @actionPage.tweet ||= Tweet.new
    @actionPage.call_campaign ||= CallCampaign.new
    @actionPage.email_campaign ||= EmailCampaign.new
    @actionPage.congress_message_campaign ||= CongressMessageCampaign.new
    10.times { @actionPage.affiliation_types.build }
    if @actionPage.enable_petition && @actionPage.petition.enable_affiliations
      @target_category = @actionPage.institutions.first.category
    end
  end

  def status
  end

  def edit_partners
    @partners = Partner.order(name: :desc)
  end

  def update
    @actionPage.background_image = nil if params[:destroy_background_image]
    @actionPage.featured_image   = nil if params[:destroy_featured_image]
    @actionPage.og_image         = nil if params[:destroy_og_image]

    @actionPage.update_attributes(action_page_params)
    if (institutions_params[:reset] && institutions_params[:reset] == "1") ||
        (institutions_params[:category] && @actionPage.institutions.empty?)
      ActionInstitution.add(action_page: @actionPage,
                            **institutions_params.to_h.symbolize_keys)
    end

    redirect_to({ action: "edit", anchor: params[:anchor] }, notice: "Action Page was successfully updated.")
  end

  def destroy
    @actionPage.destroy
    redirect_to admin_action_pages_path, notice: "Deleted action page: #{@actionPage.title}"
  end


  def preview
    @actionPage.attributes = action_page_params

    if @actionPage.enable_redirect
        redirect_to @actionPage.redirect_url, status: 301
      return
    end

    flash.now[:notice] = "This is a preview. Your changes have NOT been saved."

    set_action_display_variables

    render "action_page/show", layout: "application"
  end

  def duplicate
    @actionPage = ActionCloner.run(@actionPage)
    render "new"
  end

  def events
    set_dates
    @events = @actionPage.events.in_range(@start_date, @end_date)
    respond_to do |format|
      format.html do
        @summary = @events.summary
        if @actionPage.enable_congress_message?
          action_events = @actionPage.events.actions
                                     .where("json_extract_path(properties, 'customizedMessage') is not null")
          @total = action_events.count
          @customized = action_events.where("properties ->> 'customizedMessage' = 'true'").count
        end
      end
      format.json do
        render json: @events.chart_data(
                 type: params[:type],
                 range: @start_date..@end_date
               )
      end
    end
  end

  def events_table
    set_dates
    @events = @actionPage.events.in_range(@start_date, @end_date)
    @counts = @events.table_data
    @summary = @events.summary
    if @actionPage.enable_congress_message?
      @fills = @actionPage.congress_message_campaign.date_fills(@start_date, @end_date)
    end
  end

  def homepage
    @live_actions = ActionPage.status("live").order(:title)
    @featured_action_pages = FeaturedActionPage.load_for_edit
  end

  def update_featured_action_pages
    @featured_action_pages = FeaturedActionPage.load_for_edit
    params[:featured_action_pages].each do |i, featured_page_params|
      @featured_action_pages[i.to_i].update(featured_page_params.permit(:weight, :action_page_id))
    end

    redirect_to({ action: "homepage" }, notice: "Featured pages updated")
  end

  private

  def set_action_page
    @actionPage = ActionPage.friendly.find(params[:id] || params[:action_page_id])
  end

  def set_source_files
    @source_files = SourceFile.order(created_at: :desc).limit(12)
  end

  def set_petition_targets
    @target_categories = Institution.categories
  end

  def set_partners
    @partners = Partner.order(name: :desc)
  end

  def action_page_params
    params.require(:action_page).permit(
      :title, :summary, :description, :category_id, :related_content_url, :featured_image,
      :enable_call, :enable_petition, :enable_email, :enable_tweet,
      :enable_congress_message, :og_title, :og_image, :share_message, :published,
      :call_campaign_id, :what_to_say, :redirect_url, :email_text, :enable_redirect,
      :victory, :victory_message, :archived_redirect_action_page_id, :archived, :status,
      partner_ids: [],
      action_page_images_attributes: [:id, :action_page_image],
      call_campaign_attributes: [:id, :title, :message, :call_campaign_id],
      petition_attributes: [:id, :title, :description, :goal, :enable_affiliations],
      affiliation_types_attributes: [:id, :name],
      tweet_attributes: [
        :id, :target, :target_house, :target_senate, :message, :cta, :bioguide_id,
        tweet_targets_attributes: [:id, :_destroy, :twitter_id, :image]
      ],
      email_campaign_attributes: [
        :id, :message, :subject, :target_house, :target_senate, :target_email,
        :email_addresses, :target_bioguide_id, :bioguide_id, :alt_text_email_your_rep,
        :alt_text_look_up_your_rep, :alt_text_extra_fields_explain, :topic_category_id,
        :alt_text_look_up_helper, :alt_text_customize_message_helper, :campaign_tag
      ],
      congress_message_campaign_attributes: [
        :id, :message, :subject, :target_house, :target_senate, { target_bioguide_list: [] },
        :topic_category_id, :alt_text_email_your_rep, :alt_text_look_up_your_rep,
        :alt_text_extra_fields_explain, :alt_text_look_up_helper,
        :alt_text_customize_message_helper, :campaign_tag,
        :enable_customization_notice
      ],
      partnerships_attributes: [:id, :enable_mailings]
    )
  end

  def institutions_params
    return {} unless params.has_key? :institutions
    params.require(:institutions).permit(%i(category reset))
  end

  def filter_params
    params.permit(:q, :date_range, :utf8,
                  action_filters: %i(type status author category))
  end

  def purge_cache
    if Rails.application.secrets.fastly_api_key.present?
      fastly = Fastly.new(api_key: Rails.application.secrets.fastly_api_key)
      fastly.purge action_page_url(@actionPage)
    end
  end

  def filter_action_pages
    pages = ActionPage.order(created_at: :desc)
    pages = pages.search(filter_params[:q]) if filter_params[:q].present?
    filters = filter_params[:action_filters].to_h || {}
    filters[:date_range] = filter_params[:date_range]
    ActionPageFilters.run(relation: pages, **filters.transform_keys(&:to_sym))
  end
end
