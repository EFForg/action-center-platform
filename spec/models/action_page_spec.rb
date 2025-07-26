require "rails_helper"

describe ActionPage do
  let(:attr) { FactoryBot.attributes_for :action_page }

  it "creates a new instance given a valid attribute" do
    expect do
      ActionPage.create!(attr)
    end.to change { ActionPage.count }.by(1)
  end

  it "knows when to redirect from an archived action" do
    action_page = FactoryBot.build_stubbed :archived_action_page
    expect(action_page.redirect_from_archived_to_active_action?).to be_truthy
  end

  # The test was a no-go because of the ajaxy html requiring nils... and Then
  # changing them from nils to ""???  Needs effeciency review before crashyness review
  # it "should not allow the creation of a model with so few attrs that it would crash the views" do
  #   expect {
  #     ActionPage.create!({ })
  #   }.to raise_exception(ActiveRecord::RecordInvalid)
  #
  #   expect(ActionPage.count).to eq 0
  # end

  describe "slug" do
    let(:page) { FactoryBot.create(:action_page) }
    let(:new_slug) { "a-better-slug" }

    it "has a friendly slug" do
      expect(page.slug).to eq(page.title.downcase.tr(" ", "-"))
    end

    it "updates the slug when title changes" do
      expect { page.update(title: "something else") }.to change { page.slug }
    end

    it "does not update slug when unrelated attr changes" do
      expect { page.update(summary: "something else") }
        .not_to change { page.slug }
    end

    context "when a dev has added a custom slug" do
      before { page.update(slug: new_slug) }

      it "remembers the new slug" do
        expect(page.slug).to eq(new_slug)
      end

      it "updates the slug when the title changes" do
        expect { page.update(title: "something else") }
          .to change { page.slug }
      end

      it "does not update slug when unrelated attr changes" do
        expect { page.update(summary: "something else") }
          .not_to change { page.slug }
      end
    end

    context "with historical slugs" do
      # This is here as documentation of FriendlyId's behavior,
      # because it surprised me a little, and it might surprise you.
      # FriendlyId's `history` module remembers all of a model's slugs
      # and prevents new models from duplicating them.
      # This is cool for supporting old links, but the way FriendlyId handles
      # duplication is to append a UUID onto the end of the title,
      # eg: "my-awesome-action-page-de6d58bf-6033-4876-9f79-ee3f9d9ff043"
      # which, in my opinion, is not very friendly.

      let(:old_slug) { page.slugs.first }
      before { page.update(slug: new_slug) }

      it "does not allow slug conflicts" do
        expect(FactoryBot.create(:action_page, slug: old_slug).slug)
          .not_to eq(old_slug)
      end
    end
  end

  describe "counter cache" do
    let(:page) { FactoryBot.create(:action_page_with_petition) }
    before(:each) do
      FactoryBot.create_list(:ahoy_view, 2, action_page: page)
      FactoryBot.create(:ahoy_signature, action_page: page)
      page.reload
    end
    it "counts actions taken" do
      expect(page.action_count).to eq(1)
    end
    it "counts views" do
      expect(page.view_count).to eq(2)
    end
  end

  describe "#actions_taken_percent" do
    it "calculates the percentage of views that led to actions" do
      page = FactoryBot.create(:action_page_with_petition)
      FactoryBot.create_list(:ahoy_view, 3, action_page: page)
      FactoryBot.create_list(:ahoy_signature, 2, action_page: page)
      page.reload
      expect(page.actions_taken_percent).to eq((2 / 3.0) * 100)
    end
    it "returns all zeroes when no events" do
      page = FactoryBot.create(:action_page)
      expect(page.actions_taken_percent).to eq(0)
    end
  end

  describe ".type(types)" do
    let(:call) { FactoryBot.create(:action_page_with_call) }
    let(:congress_message) { FactoryBot.create(:action_page_with_congress_message) }
    let(:email) { FactoryBot.create(:action_page_with_email) }
    let(:petition) { FactoryBot.create(:action_page_with_petition) }
    let(:tweet) { FactoryBot.create(:action_page_with_tweet) }

    before do
      [call, congress_message, email, petition, tweet]
    end

    it "returns a scope containing only the given action types" do
      calls = ActionPage.type("call")
      expect(calls).to contain_exactly(call)

      calls_and_tweets = ActionPage.type(%w[call tweet])
      expect(calls_and_tweets).to contain_exactly(call, tweet)

      all = ActionPage.type("call", "congress_message", "email", "petition", "tweet")
      expect(all).to contain_exactly(call, congress_message, email, petition, tweet)
    end

    it "raises an ArgumentError when an invalid type is given" do
      expect { ActionPage.type("unknown") }.to raise_error(ArgumentError)
    end
  end

  describe ".status(status)" do
    shared_examples "returns only the given status" do |status, action|
      it status do
        action = FactoryBot.create(*action)
        result = ActionPage.status(status)
        expect(result).to contain_exactly(action)
      end
    end

    context "not live" do
      before { FactoryBot.create(:action_page) }

      it_behaves_like "returns only the given status", "archived",
                      [:action_page, { archived: true }]

      it_behaves_like "returns only the given status", "victory",
                      [:action_page, { victory: true }]

      it_behaves_like "returns only the given status", "draft",
                      [:action_page, { published: false }]
    end

    context "live action" do
      before { FactoryBot.create(:action_page, published: false) }
      it_behaves_like "returns only the given status", "live",
                      [:action_page, { published: true }]
    end

    it "raises an ArgumentError when an invalid status is given" do
      expect { ActionPage.status("unknown") }.to raise_error(ArgumentError)
    end
  end

  describe "attached images" do
    let(:default_image) { "missing.png" }
    context "none present" do
      it "defaults to missing.png" do
        page = ActionPage.create!(attr)
        expect(page.image.url).to match default_image
      end
    end
    context "attached featured image" do
      let(:default_url) { "https://default.com/#{default_image}" }
      let(:featured_url) { "https://featured.com/display.png" }
      let(:og_url) { "https://og.com/og-img.png" }

      def image_double(**stubs)
        instance_double("ActionPageImageUploader",
                        default_url: default_url, **stubs)
      end

      let!(:featured_double) { image_double(url: featured_url) }
      let!(:og_double) { image_double(url: og_url) }
      let!(:action_page) do
        FactoryBot.build(:action_page).tap do |page|
          allow(page).to receive(:featured_image).and_return(featured_double)
        end
      end

      it "returns the featured image url" do
        expect(action_page.image.url).to eq(featured_url)
      end

      context "AND og image" do
        it "returns the og image url" do
          allow(action_page).to receive(:og_image).and_return(og_double)
          expect(action_page.image.url).to eq(og_url)
        end
      end
    end
  end
end
