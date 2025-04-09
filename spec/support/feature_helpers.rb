module FeatureHelpers
  def sign_in_user(user)
    visit "/login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def sign_out_user(_user)
    find("#nav-modal-toggle").click
    find("input[value='Logout']", visible: :all, match: :first).click
  end
end
