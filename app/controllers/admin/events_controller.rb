class Admin::EventsController < Admin::ApplicationController
  include DateRange
  before_action :set_dates

  def index
    @events = Ahoy::Event.all.in_range(@start_date, @end_date)
    respond_to do |format|
      format.html { @summary = @events.summary }
      format.json {
        render json: @events.chart_data(
                 type: params[:type],
                 range: @start_date..@end_date
               )
      }
    end
  end
end
