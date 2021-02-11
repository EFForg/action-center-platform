class UserMailer < ActionMailer::Base
  helper ApplicationHelper
  helper ActionPageHelper
  layout "email"
  after_action :check_bounces

  def thanks_message(email, actionPage, options = {})
    @email = email
    @user = options[:user]
    @actionPage = actionPage
    @name = options[:name].presence || "Friend of Digital Freedom"
    mail(to: email, subject: "Thanks for taking action")
  end

  def signup_attempt_with_existing_email(user, _options = {})
    @user = user
    @email = user.email
    @token = user.reset_password_token
    mail(to: @email, subject: "Did you forget your password?")
  end

  private

  def check_bounces
    mail.perform_deliveries = false unless Bounce.find_by(email: @email.downcase).nil?
  end
end
