require "rails_helper"

describe ActionPage do

  let(:attr) { FactoryGirl.attributes_for :action_page }

  it "creates a new instance given a valid attribute" do
    expect {
      ActionPage.create!(attr)
    }.to change{ActionPage.count}.by(1)
  end

  it "knows when to redirect from an archived action" do
    action_page = FactoryGirl.build_stubbed :archived_action_page
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

  describe 'slug' do
    let(:page) { FactoryGirl.create(:action_page) }
    let(:new_slug) { 'a-better-slug' }

    it 'has a friendly slug' do
      expect(page.slug).to eq(page.title.downcase.gsub(' ', '-'))
    end

    it 'updates the slug when title changes' do
      expect { page.update(title: 'something else') }
        .to change { page.slug }
    end

    it 'does not update slug when unrelated attr changes' do
      expect { page.update(summary: 'something else') }
        .not_to change { page.slug }
    end

    context 'when a dev has added a custom slug' do
      before { page.update(slug: new_slug) }

      it 'remembers the new slug' do
        expect(page.slug).to eq(new_slug)
      end

      it 'updates the slug when the title changes' do
        expect { page.update(title: 'something else') }
          .to change { page.slug }
      end

      it 'does not update slug when unrelated attr changes' do
        expect { page.update(summary: 'something else') }
          .not_to change { page.slug }
      end
    end

    context 'with historical slugs' do
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

      it 'does not allow slug conflicts' do
        expect(FactoryGirl.create(:action_page, slug: old_slug).slug)
          .not_to eq(old_slug)
      end
    end
  end
end
