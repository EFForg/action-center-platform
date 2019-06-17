class Admin::CongressMessageCampaignsController < Admin::ApplicationController
  before_action :set_congress_message_campaign

  allow_collaborators_to :congress_tabulation, :staffer_report

  def congress_tabulation
  end

  def staffer_report
    @bioguide_id = params[:bioguide_id]
    render "admin/congress_message_campaigns/staffer_report", layout: "admin-blank"
  end

  private

  def set_congress_message_campaign
    @congress_message_campaign = CongressMessageCampaign.find(params[:id])
  end
end
