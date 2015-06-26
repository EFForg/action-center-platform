class UserMailer < ActionMailer::Base
  helper ApplicationHelper
  helper ActionPageHelper
  layout 'email'
  after_filter :check_bounces

  def thanks_message(email, actionPage, options={})
    @email = email
    @user = options[:user]
    @actionPage = actionPage
    @name = options[:name]
    mail(to: email, subject: 'Thanks for taking action')
  end

  private

  def check_bounces
    unless Bounce.find_by_email(@email.downcase).nil?
      mail.perform_deliveries = false
    end
  end
end
