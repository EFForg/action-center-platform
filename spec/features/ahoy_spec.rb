require "rails_helper"

# TODO:
# These intermittently fail! I am not sure why but don't want to increase the
# wait time in #take_email_action past 5
#
# For the logged in user spec, can also / maybe should test the display on the user
# page instead?
RSpec.feature "Ahoy", type: :feature, js: true do
  let!(:action_page) { FactoryBot.create(:email_campaign).action_page }
  let!(:user) { FactoryBot.create(:user) }

  context "no user logged in" do
    it "records an event when an action is taken" do
      expect { take_email_action(action_page) }.to \
        change { action_page.reload.action_count }.from(0).to(1)
    end
  end

  context "user logged in" do
    before { sign_in_user(user) }
    context "has enabled action tracking" do
      before { user.update(record_activity: true) }
      it "creates an event with the user after taking an action" do
        expect { take_email_action(action_page) }.to \
          change { user.reload.taken_action?(action_page) }.from(false).to(true)
      end
    end
    context "has NOT enabled action tracking" do
      it "records an event without a user ID" do
        expect { take_email_action(action_page) }.to \
          change { action_page.reload.action_count }.from(0).to(1)
        expect(user.actions).to be_empty
      end
    end
  end
  
  def take_email_action(action_page)
    visit action_page_path(action_page)
    click_on "Use default mail client"
    expect(page).to have_content("Thank You!", wait: 5)
  end
end
