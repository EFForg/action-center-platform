module DeviseHelper
  # Customized to add model error instead of flashing the error.
  def devise_error_messages!
    flash_alerts = []
    error_key = "errors.messages.not_saved"

    flash_alerts.push("This account was locked due to too many failed login attempts.  Check your email for a link to unlock.") if locked_account?

    if !flash.empty?
      flash_alerts.push(flash[:error]) if flash[:error]
      flash_alerts.push(flash[:alert]) if flash[:alert]
      flash_alerts.push(flash[:notice]) if flash[:notice]
      error_key = "devise.failure.invalid"
    end

    return "" if resource.errors.empty? && flash_alerts.empty?
    @hasErrorMessages = true
    errors = resource.errors.empty? ? flash_alerts : resource.errors.full_messages

    messages = errors.map { |msg| content_tag(:p, msg) }.join
    sentence = I18n.t(error_key, count: errors.count,
                                 resource: resource.class.model_name.human.downcase)

    if !flash[:notice] | flash[:alert]
      panel_title = "<div class='panel-heading'><h3 class='panel-title'>Error</h3></div>"
    end

    html = <<-HTML
    <div class="panel panel-default error_explanation">
      #{panel_title}
      <div class="panel-body">
      #{messages}
      </div>
    </div>
    HTML

    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def devise_error_messages?
    @hasErrorMessages ? true : false
  end

  def locked_account?
    u = User.find_by_email(@user.email)
    u && u.access_locked?
  end
end
