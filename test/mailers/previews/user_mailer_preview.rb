class UserMailerPreview < ActionMailer::Preview
  def thanks_message
    user = User.first
    actionpage = ActionPage.last
    UserMailer.thanks_message('sina.khanifar@gmail.com',actionpage,user)
  end

  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, {})
  end

  def reset_password_instructions
    Devise::Mailer.confirmation_instructions(User.first, {})
  end
end
