#require 'spec_helper'
require 'rails_helper'

describe SubscriptionsController do
  before :each do
  end

  let(:valid_attributes) { {
      "email" => "johnsmith@eff.org",
      "mailing_list" => "effector"
    } }

  it "should test" do

    binding.pry
    post "/subscrpitions", valid_attributes

    #expect(true).to be true

  end
end
