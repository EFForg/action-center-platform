require "rails_helper"

RSpec.describe "Admin Action Pages", type: :request do
  let(:valid_attributes) do
    {
      action_page: {
        title: "Save Kittens",
        summary: "Save kittens in great detail",
        description: "Some description",
        email_text: "",
        enable_tweet: "0"
      },
      add_targets: ""
    }
  end

  describe "Non-Privileged Users" do
    it "should prevent them creating action pages" do
      expect do
        post "/admin/action_pages", params: valid_attributes
      end.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe "Admins" do
    before(:each) do
      @admin = FactoryBot.create(:admin_user)
      login @admin
    end

    it "should allow them creating action pages with valid attributes" do
      post "/admin/action_pages", params: valid_attributes

      expect(response).to redirect_to(assigns(:actionPage))
      follow_redirect!

      expect(response.code).to eq "200"
      expect(ActionPage.count).to eq 1
    end

    it "should allow them to search action pages" do
      border = FactoryBot.create(
        :action_page_with_petition,
        title: "borderpetition",
        petition_attributes: {
          description: "border surveillance petition"
        }
      )

      privacy = FactoryBot.create(
        :action_page_with_petition,
        title: "privacypetition",
        petition_attributes: { description: "online privacy" }
      )

      tweet = FactoryBot.create(
        :action_page_with_tweet,
        title: "bordertweet",
        tweet_attributes: { message: "border surveillance tweet" }
      )

      xhr :get, "/admin/action_pages?q=border+surveil"

      expect(response.body).to include(border.title)
      expect(response.body).to include(tweet.title)
      expect(response.body).not_to include(privacy.title)
    end
  end
end
