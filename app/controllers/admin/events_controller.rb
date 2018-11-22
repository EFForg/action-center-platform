class Admin::EventsController < Admin::ApplicationController
  include DateRange

  def index
    if %w(views emails congress_messages tweets calls signatures).include? params[:type]
      @data = events.send(params[:type]).group_in_range(start_date, end_date)
    else
      render nothing: true, status: :bad_request
    end
    render json: @data
  end

  def views
    @actionPage = ActionPage.friendly.find(params[:action_page_id])
    @views = @actionPage.events.views.group_in_range(start_date, end_date)
  end


  private

  def events
    if params[:action_page_id]
      action_page = ActionPage.friendly.find(params[:action_page_id])
      raise ActiveRecord::RecordNotFound unless action_page
      action_page.events
    else
      Ahoy::Event
    end
  end
end
