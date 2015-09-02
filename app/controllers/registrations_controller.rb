class RegistrationsController < Devise::RegistrationsController
  before_filter :set_create_notice, only: :create

  def set_create_notice
    flash[:notice] = "Your account has been created and is pending confirmation.  Please check your email to confirm registration."
  end
end
