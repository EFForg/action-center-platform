require "rails_helper"

RSpec.describe "Action Pages", :type => :request do

  before(:each) do
    @action_page = FactoryGirl.create(:petition_with_99_signatures_needing_1_more).action_page
  end

  it "lists action pages" do
    get "/action"

    expect(response).to render_template(:index)
    expect(response.body).to include(@action_page.title)
  end

  it "should allow cors wildcard for broad web consumption" do
    get "/action"

    cors_wildcard_presence = response.headers.any?{ |k,v| k == "Access-Control-Allow-Origin" && v == "*" }
    expect(cors_wildcard_presence).to be_truthy
  end

end
