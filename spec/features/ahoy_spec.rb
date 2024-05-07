require "rails_helper"

RSpec.feature "Ahoy", type: :feature, js: true do
  let!(:action_page) { FactoryBot.create(:email_campaign, :custom).action_page }
  let!(:user) { FactoryBot.create(:user) }

  context "user logged in" do
    before { sign_in_user(user) }
    context "has enabled action tracking" do
      before { user.update(record_activity: true) }
      it "records an event when an action is taken" do
        take_email_action(action_page)
        # expect event to exist with attributes XYZ
        expect(Ahoy::Event.last.attributes).to \
          include({ "action_page_id" => action_page.id })
      end
    end
    context "has NOT enabled action tracking" do
    end
  end
  
  context "no user logged in" do
    it "records an event when an action is taken" do
      visit action_page_path(action_page)
      take_email_action
      # expect event to exist with attributes XYZ
      expect(Ahoy::Event.last.attributes).to eq({})
    end
  end

  def take_email_action(action_page)
    visit action_page_path(action_page)
    click_on "Use default mail client"
  end
end
