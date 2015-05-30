class Admin::EmailCampaignsController < Admin::ApplicationController
  before_action :set_email_campaign

  def date_tabulation
  end

  def congress_tabulation
  end

  def staffer_report
    @bioguide_id = params[:bioguide_id]
    render 'admin/email_campaigns/staffer_report', layout: 'admin-blank'
  end

  private
  def set_email_campaign
    @email_campaign = EmailCampaign.find(params[:id])
  end

end
