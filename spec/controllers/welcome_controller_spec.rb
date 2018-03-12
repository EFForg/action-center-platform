require "rails_helper"

RSpec.describe WelcomeController, type: :controller do
  it "should get the root page at least..." do
    get :index
    expect(response.code).to eq "200"
  end
end
