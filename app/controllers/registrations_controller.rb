class RegistrationsController < Devise::RegistrationsController
  after_filter :set_create_notice, only: :create

  def set_create_notice
    cookies[:sweetAlert] = JSON.dump({title: "Thanks!", text: "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."})
    flash[:notice] = nil
  end
end
