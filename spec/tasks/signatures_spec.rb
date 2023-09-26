require "rails_helper"
require "rake"

describe "signatures namespace rake tasks" do
  before do
    Rake.application.rake_require("tasks/signatures")
    Rake::Task.define_task(:environment)
  end

  describe "signatures:deduplicate" do
    after { Rake.application["signatures:deduplicate"].reenable }

    it "should delete signatures with non-unique emails from petitions" do
      regular_petition = FactoryBot.create(:petition_complete_with_one_hundred_signatures)

      petition_with_dups = FactoryBot.create(:petition_complete_with_one_hundred_signatures)
      # rubocop:todo Rails/SkipsModelValidations
      petition_with_dups.signatures.take(20).each { |sig| sig.update_column(:email, "dup1@example.com") }
      # rubocop:enable Rails/SkipsModelValidations
      # rubocop:todo Rails/SkipsModelValidations
      petition_with_dups.signatures.take(10).each { |sig| sig.update_column(:email, "dup2@example.com") }
      # rubocop:enable Rails/SkipsModelValidations

      distinct_emails = petition_with_dups.signatures.pluck(:email).uniq

      expect(regular_petition.signatures.select("email").distinct.count).to eq(100)
      expect(petition_with_dups.signatures.select("email").distinct.count).to eq(72)

      Rake.application.invoke_task "signatures:deduplicate"

      # Check that regular petition was unaffected and that the other contains no duplicates
      expect(regular_petition.signatures.reload.count).to eq(100)
      expect(petition_with_dups.signatures.reload.count).to eq(72)
      expect(petition_with_dups.signatures.reload.pluck(:email)).to contain_exactly(*distinct_emails)
    end

    context "with duplicate subscriptions" do
      let(:subscription) { FactoryBot.create(:subscription) }
      let(:email) { subscription.email }
      let(:partner) { subscription.partner }
      let!(:owner_subscription2) do
        FactoryBot.create(:subscription, email: email)
      end
      let!(:partner_subscription2) do
        FactoryBot.create(:subscription, partner: partner)
      end
      let!(:dup_subscription) do
        FactoryBot.create(:subscription)
                  .update_columns(email: email, partner_id: partner.id)
      end

      it "removes the newer duplicates" do
        expect(Subscription.where(email: email, partner: partner).count).to eq(2)
        expect(Subscription.where(email: email).count).to eq(3)
        expect(Subscription.where(partner: partner).count).to eq(3)

        expect { Rake.application.invoke_task "signatures:deduplicate" }
          .to change(Subscription, :count).by(-1)

        expect(Subscription.where(email: email, partner: partner).count).to eq(1)
        expect(Subscription.where(email: email).count).to eq(2)
        expect(Subscription.where(partner: partner).count).to eq(2)
      end
    end
  end
end
