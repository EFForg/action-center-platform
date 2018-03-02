module UsersHelper
  def icons_for_action_page(action_page)
    icons = []
    icons << "icon ion-ios-telephone" if action_page.enable_call
    icons << "icon ion-clipboard" if action_page.enable_petition
    icons << "icon ion-ios-email-outline" if action_page.enable_email
    icons << "icon ion-ios-filing-outline" if action_page.enable_congress_message
    icons << "icon ion-social-twitter" if action_page.enable_tweet
    icons << "icon ion-link" if action_page.enable_redirect
    icons
  end
end
