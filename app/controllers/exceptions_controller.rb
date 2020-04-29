class ExceptionsController < ActionController::Base
  layout "application"

  def show
    @exception = request.env["action_dispatch.exception"]
    @status_code = ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code
    @rescue_response = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]

    respond_to do |format|
      format.xml  { render xml: details, root: "error", status: @status_code }
      format.json { render json: { error: details }, status: @status_code }
      format.any { render "show.html", status: @status_code, layout: !request.xhr?, content_type: "text/html" }
    end
  end

  protected

  helper_method :current_user

  def current_user
    nil
  end

  def details
    @details ||= {}.tap do |h|
      I18n.with_options scope: [:exception, :show, @rescue_response], exception_name: @exception.class.name, exception_message: @exception.message do |i18n|
        h[:name]    = i18n.t "#{@exception.class.name.underscore}.title", default: i18n.t(:title, default: @exception.class.name)
        h[:message] = i18n.t "#{@exception.class.name.underscore}.description", default: i18n.t(:description, default: @exception.message)
      end
    end
  end
  helper_method :details
end
