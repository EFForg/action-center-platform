class Admin::MailerController < Admin::ApplicationController
  layout "email"

  def preview_thanks
    @actionPage = ActionPage.friendly.find params[:id]
    render file: "user_mailer/thanks_message.html.erb"
  end
end
