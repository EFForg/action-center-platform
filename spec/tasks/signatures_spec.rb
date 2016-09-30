require "rails_helper"
require "rake"

describe "signatures namespace rake tasks" do
  before do
    Rake.application.rake_require("tasks/signatures")
    Rake::Task.define_task(:environment)
  end

  describe "signatures:deduplicate" do
    it "should delete signatures with non-unique emails from petitions" do
      regular_petition = FactoryGirl.create(:petition_complete_with_one_hundred_signatures)

      petition_with_dups = FactoryGirl.create(:petition_complete_with_one_hundred_signatures)
      petition_with_dups.signatures.take(20).each{ |sig| sig.update_column(:email, "dup1@example.com") }
      petition_with_dups.signatures.take(10).each{ |sig| sig.update_column(:email, "dup2@example.com") }

      distinct_emails = petition_with_dups.signatures.pluck(:email).uniq

      expect(regular_petition.signatures.select("email").distinct.count).to eq(100)
      expect(petition_with_dups.signatures.select("email").distinct.count).to eq(82)

      Rake.application.invoke_task "signatures:deduplicate"

      # Check that regular petition was unaffected and that the other contains no duplicates
      expect(regular_petition.signatures.reload.count).to eq(100)
      expect(petition_with_dups.signatures.reload.count).to eq(82)
      expect(petition_with_dups.signatures.reload.pluck(:email)).to contain_exactly(*distinct_emails)
    end
  end
end
