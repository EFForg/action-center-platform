class Admin::EventsController < Admin::ApplicationController
  before_action :set_action_page

  def index
    if %w(views emails congress_messages tweets calls signatures).include? params[:type]
      @data = @actionPage.events.send(params[:type]).group_in_range(start_date, end_date)
    else
      render nothing: true, status: :bad_request
    end

    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def views
    @views = @actionPage.events.views.group_in_range(start_date, end_date)
  end

  private

  def set_action_page
    @actionPage = ActionPage.friendly.find(params[:action_page_id])
    raise ActiveRecord::RecordNotFound unless @actionPage
  end

  def start_date
    if params[:date_start]
      Time.zone.parse(params[:date_start])
    else
      (Time.zone.now - 1.month).beginning_of_day
    end
  end

  def end_date
    if params[:date_end]
      Time.zone.parse(params[:date_end])
    else
      Time.zone.now
    end
  end
end
