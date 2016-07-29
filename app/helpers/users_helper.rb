module UsersHelper

  def icons_for_action_page(action_page)
    icons = []
    icons << "phone" if action_page.enable_call
    icons << "clipboard" if action_page.enable_petition
    icons << "mail" if action_page.enable_email
    icons << "twitter" if action_page.enable_tweet
    icons << "link" if action_page.enable_redirect
    icons
  end
end
