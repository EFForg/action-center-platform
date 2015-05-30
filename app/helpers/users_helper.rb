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

  def get_percentile()
    user_count = current_user.events.actions.count
    @user_action_counts.percentile_rank(user_count-1).round(0)
  end

  def get_percentile_ordinalized()
    user_count = current_user.events.actions.count
    @user_action_counts.percentile_rank(user_count-1).round(0).ordinalize
  end
end
