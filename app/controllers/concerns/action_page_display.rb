module ActionPageDisplay
  extend ActiveSupport::Concern

  private

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
      @institution_category = @institutions.first.category
    end

    @topic_category = nil
    if @email_campaign and !@email_campaign.topic_category.nil?
      @topic_category = @email_campaign.topic_category.as_2d_array
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

    @related_content = RelatedContent.new(@actionPage.related_content_url)
    @related_content.load
  end

  def set_signatures
    if @petition

      # Signatures filtered by institution
      if @institution
        @signatures = @petition.signatures_by_institution(@institution)
        @institution_signature_count = @signatures.pretty_count
      elsif @petition.enable_affiliations
        @signatures = @petition.signatures
            .includes(affiliations: [:institution, :affiliation_type])
      else
        @signatures = @petition.signatures
      end

      @signatures = @signatures
                     .paginate(page: params[:page], per_page: 9)
                     .order(created_at: :desc)

      @signature_count = @petition.signatures.pretty_count
      @require_location = !@petition.enable_affiliations
    end
  end

end
