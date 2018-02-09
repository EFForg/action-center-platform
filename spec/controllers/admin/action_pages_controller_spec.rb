require "rails_helper"

RSpec.describe Admin::ActionPagesController, type: :controller do
  include Devise::TestHelpers

  let(:petition_action_page){ FactoryGirl.create(:action_page_with_petition) }

  describe "GET #index" do
    render_views

    context "user is an admin" do
      before{ login_as_admin }

      it "should have tabs and panels for create/browse actions, homepage, analytics, partners, topics, and users" do
        get :index

        expect(response).to have_http_status(:success)

        doc = Nokogiri::HTML(response.body)
        expect(doc.at_css(".create-new a")).to be_present
        expect(doc.at_css("a[data-tab=action-pages]")).to be_present
        expect(doc.at_css(".tab-pane#action-pages")).to be_present
        expect(doc.at_css("a[data-tab=homepage-settings]")).to be_present
        expect(doc.at_css(".tab-pane#homepage-settings")).to be_present
        expect(doc.at_css("a[data-tab=analytics]")).to be_present
        expect(doc.at_css(".tab-pane#analytics")).to be_present
        expect(doc.at_css("a[data-tab=partners]")).to be_present # no pane for partners, links to from separate controller
        expect(doc.at_css("a[data-tab=topics]")).to be_present
        expect(doc.at_css(".tab-pane#topics")).to be_present
        expect(doc.at_css("a[data-tab=users]")).to be_present # no pane for users, links to from separate controller
      end
    end

    context "user is a collaborator" do
      before{ login_as_collaborator }

      it "should have tabs and panels for actions and analytics, and nothing else" do
        get :index

        expect(response).to have_http_status(:success)

        doc = Nokogiri::HTML(response.body)
        expect(doc.at_css("a[data-tab=action-pages]")).to be_present
        expect(doc.at_css(".tab-pane#action-pages")).to be_present
        expect(doc.at_css("a[data-tab=analytics]")).to be_present
        expect(doc.at_css(".tab-pane#analytics")).to be_present

        expect(doc.at_css(".create-new a")).not_to be_present
        expect(doc.at_css("a[data-tab=homepage-settings]")).not_to be_present
        expect(doc.at_css(".tab-pane#homepage-settings")).not_to be_present
        expect(doc.at_css("a[data-tab=partners]")).not_to be_present
        expect(doc.at_css("a[data-tab=topics]")).not_to be_present
        expect(doc.at_css(".tab-pane#topics")).not_to be_present
        expect(doc.at_css("a[data-tab=users]")).not_to be_present
      end
    end
  end

  describe "PATCH #update" do
    let(:page) { FactoryGirl.create(:action_page) }
    let(:image) { Rails.root.join("spec/fixtures/images/eff.png") }
    let(:update) { put :update, attrs }
    let(:targets) { "" }
    let(:page_attrs) { {} }
    let(:attrs) do
      {
        id: page.slug,
        action_page: {
          title: "", # the page passes all attributes, which confuses the model
          congress_message_campaign_attributes: {
            target_specific_legislators: "0",
          },
        }.merge(page_attrs),
        add_targets: targets
      }
    end

    before do
      stub_request(:post, %r(api.fastly.com))
        .to_return(status: 200, body: "", headers: {})
      login_as_admin
    end

    context "with a tweet" do
      let(:page) { ActionPage.find_by(tweet_id: tweet.id) }
      let(:tweet) { FactoryGirl.create(:tweet) }
      let(:targets) { "rep1\r\nrep2" }

      it "saves twitter targets" do
        expect { update }.to change(tweet.tweet_targets, :count)
          .by(targets.split("\r\n").count)
      end
    end

    context "with a custom slug" do
      let(:slug) { "slug" }

      before do
        page.update(slug: slug)
        expect(page.slug).to eq(slug)
      end

      context "with non-title-related changes" do
        let(:page_attrs) { { summary: "a new summary" } }

        it "does not change the slug" do
          update
          expect(page.reload.slug).to eq(slug)
        end
      end

      context "with a title change" do
        let(:page_attrs) { { title: "a new title" } }

        it "changes the slug" do
          update
          expect(page.reload.slug).not_to eq(slug)
        end
      end
    end
  end
end
