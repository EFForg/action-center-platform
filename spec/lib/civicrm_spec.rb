require "rails_helper"

describe CiviCRM do
  before do
    stub_civicrm
  end

  describe "self.get_checksum" do
    it "calls the civicrm API with method 'generate_checksum'" do
      CiviCRM::get_checksum(123)
      assert_requested :post, CiviCRM::supporters_api_url, body: /generate_checksum/
    end
  end
end

shared_examples_for "civicrm_user_methods" do
  subject { described_class.new }

  describe ".manage_subscription_url!" do
    it "encodes a checksum" do
      allow(CiviCRM).to receive(:get_checksum).and_return("xyz")
      expect(subject.manage_subscription_url!).to include("cs=xyz")
    end
  end
end
