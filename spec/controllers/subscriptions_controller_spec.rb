#require 'spec_helper'
require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do



  let(:valid_attributes) { {
      "email" => "johnsmith@eff.org",
      "mailing_list" => "effector"
    } }

  it "should test" do

    binding.pry
    #post "/subscrpitions", valid_attributes
    post :create, valid_attributes

    #expect(true).to be true

  end
end
