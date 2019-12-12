class Admin::EventsController < Admin::ApplicationController
  include DateRange

  def index
    set_dates
    if Ahoy::Event.action_types.include?(params[:type].try(:to_sym))
      @events = Ahoy::Event.all.send(params[:type])
      @data = @events.group_in_range(@start_date, @end_date)
    else
      @events = Ahoy::Event.all
      @data = @events.group_by_type_in_range(@start_date, @end_date)
    end
    @summary = @events.summary(@start_date, @end_date)

    respond_to do |format|
      format.html
      format.json { render json: @data }
    end
  end
end
