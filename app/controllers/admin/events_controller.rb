class Admin::EventsController < Admin::ApplicationController
  include DateRange

  def index
    if params[:type].blank?
      @data = events.group_by_type_in_range(start_date, end_date)
      @columns = Ahoy::Event.action_types(action_page)
      if action_page.present? && action_page.enable_congress_message?
        @fills = action_page.congress_message_campaign.date_fills(start_date, end_date)
      end
    elsif Ahoy::Event.action_types.include? params[:type].to_sym
      @data = events.send(params[:type]).group_in_range(start_date, end_date)
    else
      render nothing: true, status: :bad_request
      return
    end
    respond_to do |format|
      format.html { render "table" }
      format.json { render json: @data }
    end
  end

  private

  def action_page
    if params[:action_page_id]
      @actionPage ||= ActionPage.friendly.find(params[:action_page_id])
    end
  end

  def events
    if action_page
      action_page.events
    else
      Ahoy::Event
    end
  end
end
