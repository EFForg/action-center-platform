require "rails_helper"

RSpec.describe "Admin image gallery", type: :system, js: true do
  before { warden_sign_in(FactoryBot.create(:admin_user)) }
end
