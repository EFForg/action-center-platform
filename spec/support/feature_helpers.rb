module FeatureHelpers
  def sign_in_user(user)
    stub_civicrm
    visit "/login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def sign_out_user(_user)
    find("#nav-modal-toggle").click
    find("input[value='Logout']", visible: :all, match: :first).click
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
