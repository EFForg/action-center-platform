module Tooling
  extend ActiveSupport::Concern

  private

  def create_partner_subscription
    return unless @action_page

    @action_page.partners.each do |partner|
      Subscription.create(partner_signup_params.merge(partner: partner)) if params["#{partner.code}_subscribe"] == "1"
    end
  end

  def deliver_thanks_message
    @email ||= current_user.try(:email) || params[:email] || params.dig(:subscription, :email)
    UserMailer.thanks_message(@email, @action_page, user: @user, name: @name).deliver_now if @email.present?
  end
end
