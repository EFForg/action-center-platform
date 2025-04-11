module JavascriptHelpers
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
end
