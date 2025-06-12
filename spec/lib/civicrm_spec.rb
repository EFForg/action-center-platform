require "rails_helper"

describe Civicrm do
  before do
    stub_civicrm
  end

  describe "self.get_checksum" do
    it "calls the civicrm API with method 'generate_checksum'" do
      Civicrm.get_checksum(123)
      assert_requested :post, Civicrm.supporters_api_url, body: /generate_checksum/
    end
  end
end
