class Admin::EventsController < Admin::ApplicationController
  include DateRange
  before_action :set_dates

  def index
    @events = Ahoy::Event.all.in_range(@start_date, @end_date)
    @events = @events.send(params[:type]) if valid_type_present?

    respond_to do |format|
      format.html { @summary = @events.summary }
      format.json { render json: @events.group_by_date }
    end
  end

  private

  def valid_type_present?
    Ahoy::Event.action_types.include?(params[:type].try(:to_sym))
  end
end
