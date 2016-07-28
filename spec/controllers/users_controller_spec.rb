require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::TestHelpers

  let(:ahoy) {
    ahoy = Ahoy::Tracker.new
  }

  before(:each) do
    # Login
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:user)
  end

  describe "GET #show" do
    it "shows your rank compared to other users" do
      # Users take several actions
      track_views_and_actions

      get :show
      expect(assigns(:percentile)).to eq("50th")
    end
  end
end

def track_views_and_actions
  FactoryGirl.create(:user)
  ahoy.authenticate(FactoryGirl.create(:user))
  3.times { track_signature }

  ahoy.authenticate(FactoryGirl.create(:user))
  1.times { track_signature }

  ahoy.authenticate(subject.current_user)
  2.times { track_signature }
  track_view
end

def track_signature
  @actionPage = FactoryGirl.create(:action_page_with_petition)
  ahoy.track "Action",
    { type: "action", actionType: "signature", actionPageId: @actionPage.id },
    action_page: @actionPage
end

def track_view
  @actionPage = FactoryGirl.create(:action_page_with_petition)
  ahoy.track "View",
    { type: "action", actionType: "view", actionPageId: @actionPage.id },
    action_page: @actionPage
end
