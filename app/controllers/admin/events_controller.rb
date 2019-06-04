class Admin::EventsController < Admin::ApplicationController
  include DateRange

  def index
    if params[:type].blank?
      @data = events.each_type(action_page) do |t|
        t.group_in_range(start_date, end_date)
      end
    elsif Ahoy::Event.types.include? params[:type].to_sym
      @data = events.send(params[:type]).group_in_range(start_date, end_date)
    else
      # @TODO fix double render error
      render nothing: true, status: :bad_request
    end
    render json: @data
  end

  def views
    @actionPage = ActionPage.friendly.find(params[:action_page_id])
    @views = @actionPage.events.views.group_in_range(start_date, end_date)
  end

  private

  def action_page
    if params[:action_page_id]
      @actionPage ||= ActionPage.friendly.find(params[:action_page_id])
      raise ActiveRecord::RecordNotFound unless @actionPage
      @actionPage
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
