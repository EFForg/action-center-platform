module JavascriptHelpers
  # TODO:
  # - move JS test only methods from FeatureHelpers here
  # - change type of all "feature" specs to "system" or "js"
  # - if we need to stub civi before all system tests, do it in rails helper
  # - switch to warden_sign_in for JS tests
  # - switch to the devise helper for non-JS system tests
  # - also, should be able to see if this improves test flakiness fairly easily
  #   it's been 50%+ of my recent rspec local runs
  def warden_sign_in(user)
    # this calls a helper from Warden::Test::Helpers
    login_as(user, scope: :user)
  end
end
