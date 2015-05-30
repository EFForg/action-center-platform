class UserMailer < ActionMailer::Base
  helper ApplicationHelper
  helper ActionPageHelper
  layout 'email'

  def thanks_message(email, actionPage, options={})
    @user = options[:user]
    @actionPage = actionPage
    @name = options[:name]
    mail(to: email, subject: 'Thanks for taking action')
  end
end
