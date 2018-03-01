class WelcomeController < ApplicationController
  def index
    @actionPages = FeaturedActionPage.includes(:action_page).
                                      order("weight desc").
                                      map(&:action_page).
                                      compact
    @featuredActionPage = @actionPages.pop
    @actionPages = @actionPages.reverse
  end
end
