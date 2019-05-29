class Admin::ActionPagesController < Admin::ApplicationController
  include DateRange
  before_action :set_action_page, except: [:new, :index, :create, :update_featured_pages]
  before_action :cleanup_congress_message_params, only: [:update]
  before_action :set_s3_post, only: [:new, :edit, :create, :update]
  skip_before_action :verify_authenticity_token, only: [:update_featured_pages]
  after_action :purge_cache, only: [:update, :publish]

  allow_collaborators_to :index, :edit

  def index
    @actionPages = filter_action_pages
    @featuredActionPages = FeaturedActionPage.order("weight").
                                              includes(:action_page).
                                              map(&:action_page)

    if request.xhr?
      render partial: "admin/action_pages/panel_action_pages"
    end
  end

  def update_featured_pages
    FeaturedActionPage.destroy_all
    featuredPages = Array.new
    featuredPages << { action_page_id: featured_page_params[:fp4], weight: 4 }
    featuredPages << { action_page_id: featured_page_params[:fp3], weight: 3 }
    featuredPages << { action_page_id: featured_page_params[:fp2], weight: 2 }
    featuredPages << { action_page_id: featured_page_params[:fp1], weight: 1 }
    FeaturedActionPage.create(featuredPages)
    #render :json => {success: true}, :status => 200
    redirect_to({ action: "index" }, notice: "Featured pages updated")
  end

  def new
    @actionPage = ActionPage.new
    @petition = @actionPage.petition = Petition.new
    @tweet    = @actionPage.tweet    = Tweet.new
    @call_campaign = @actionPage.call_campaign = CallCampaign.new
    # Todo - Gotta convert email campaigns to singular - Thomas
    @email_campaign = @actionPage.email_campaign = EmailCampaign.new
    @congress_message_campaign = @actionPage.congress_message_campaign = CongressMessageCampaign.new
    @categories = Category.all.order :title
    @topic_categories = TopicCategory.all.order :name
    @actionPage.email_text = Rails.application.config.action_pages_email_text
  end

  def create
    @actionPage = ActionPage.new(action_page_params)
    if @actionPage.save
      add_twitter_targets
      redirect_to_action_page
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

    @categories = Category.all.order :title
    @topic_categories = TopicCategory.all.order :name
  end

  def update
    @actionPage.background_image = nil if params[:destroy_background_image]
    @actionPage.featured_image   = nil if params[:destroy_featured_image]
    @actionPage.og_image         = nil if params[:destroy_og_image]

    @actionPage.update_attributes(action_page_params)

    add_twitter_targets

    redirect_to({ action: "edit", anchor: params[:anchor] }, notice: "Action Page was successfully updated.")
  end

  def destroy
    @actionPage.destroy
    redirect_to admin_action_pages_path, notice: "Deleted action page: #{@actionPage.title}"
  end

  def show
    render json: @actionPage
  end

  def publish
    @actionPage.update(published: true)
    redirect_to admin_action_pages_path, notice: "Published page: #{@actionPage.title}"
  end

  def unpublish
    @actionPage.update(published: false)
    redirect_to admin_action_pages_path, notice: "Unpublished page: #{@actionPage.title}"
  end

  def preview
    @actionPage.attributes = action_page_params

    if @actionPage.enable_redirect
        redirect_to @actionPage.redirect_url, status: 301
      return
    end

    flash.now[:notice] = "This is a preview. Your changes have NOT been saved."

    @title = @actionPage.title
    @petition = @actionPage.petition
    @tweet = @actionPage.tweet
    @email_campaign = @actionPage.email_campaign

    # Shows a mailing list if no tools enabled
    @no_tools = [:tweet, :petition, :call, :email, :congress_message].none? do |tool|
      @actionPage.send "enable_#{tool}".to_sym
    end

    if @petition
      @signatures = @petition.signatures.order(created_at: :desc).paginate(page: 1, per_page: 5)
      @signature_count = @petition.signatures.pretty_count

      @top_institutions = @actionPage.institutions.top(300)
      @institutions = @actionPage.institutions.order(:name)
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

    render "action_page/show", layout: "application"
  end

  private

  def set_action_page
    @actionPage = ActionPage.friendly.find(params[:id] || params[:action_page_id])
  end

  def set_s3_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}",
                                               success_action_status: "201", acl: "public-read")
  end

  def redirect_to_action_page
    redirect_to action_page_path(@actionPage)
  end

  def add_twitter_targets
    tweet_params["add_targets"].each_line do |t|
      target = TweetTarget.find_or_create_by twitter_id: t.strip, tweet_id: @actionPage.tweet.id
      @actionPage.tweet.tweet_targets.push(target)
    end
  end

  def default_values
    self.email_text ||= "default value"
  end

  def action_page_params
    params.require(:action_page).permit(
      :title, :summary, :description, :category_id, :featured_image, :background_image,
      :enable_call, :enable_petition, :enable_email, :enable_tweet,
      :enable_congress_message, :og_title, :og_image, :share_message, :published,
      :call_campaign_id, :what_to_say, :redirect_url, :email_text, :enable_redirect,
      :victory, :victory_message, :archived_redirect_action_page_id, :archived,
      partner_ids: [], action_page_images_attributes: [:id, :action_page_image],
      call_campaign_attributes: [:id, :title, :message, :call_campaign_id],
      petition_attributes: [:id, :title, :description, :goal, :enable_affiliations],
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
        :id, :message, :subject, :target_house, :target_senate, :target_bioguide_ids,
        :topic_category_id, :alt_text_email_your_rep, :alt_text_look_up_your_rep,
        :alt_text_extra_fields_explain, :alt_text_look_up_helper,
        :alt_text_customize_message_helper, :campaign_tag
      ]
    )
  end

  def tweet_params
    params.permit(:add_targets)
  end

  def featured_page_params
    params.permit(:fp1, :fp2, :fp3, :fp4)
  end

  def purge_cache
    if Rails.application.secrets.fastly_api_key.present?
      fastly = Fastly.new(api_key: Rails.application.secrets.fastly_api_key)
      fastly.purge action_page_url(@actionPage)
    end
  end

  def cleanup_congress_message_params
    if params[:action_page][:congress_message_campaign_attributes][:target_specific_legislators] != "1"
      params[:action_page][:congress_message_campaign_attributes][:target_bioguide_ids] = nil
    else
      people = params[:action_page][:congress_message_campaign_attributes][:target_bioguide_ids].select(&:present?)
      params[:action_page][:congress_message_campaign_attributes][:target_bioguide_ids] = people.join(", ")
    end
  end

  def filter_action_pages
    pages = ActionPage.order(created_at: :desc)
    pages = pages.search(params[:q]) if params[:q].present?

    default = {
      call: "1",
      congress_message: "1",
      email: "1",
      petition: "1",
      redirect: "1",
      tweet: "1",
    }

    if params.key?(:action_type) && params[:action_type] != default.stringify_keys
      pages = pages.type(params[:action_type].keys)
    end

    pages
  end
end
