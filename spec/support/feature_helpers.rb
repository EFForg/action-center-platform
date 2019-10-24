module FeatureHelpers
  def sign_in_user(user)
    visit "/login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def disable_call_tool
    allow(CallTool).to receive(:enabled?).and_return(false)
  end
end
