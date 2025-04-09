module JavascriptHelpers
  # TODO:
  # - switch to warden_sign_in for JS tests
  # - switch to the devise helper for non-JS system tests
  def warden_sign_in(user)
    # this calls a helper from Warden::Test::Helpers
    login_as(user, scope: :user)
  end

  def fill_in_editor(locator, with:)
    within_frame find(locator, visible: :all).sibling("div").find("iframe") do
      within_frame find("#epiceditor-editor-frame") do
        find("body").set(with)
      end
    end
  end

  def fill_in_select2(locator, with:)
    find(locator).sibling(".select2-container").click
    find("li.select2-results__option[role=treeitem]", text: with).click
  end

  def tempermental(try: 2.times)
    try.each do |attempt|
      yield
      break
    rescue RSpec::Expectations::ExpectationNotMetError => e
      raise e if attempt == try.size - 1
    end
  end
end
