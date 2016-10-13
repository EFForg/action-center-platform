require "rails_helper"

RSpec.describe CongressController, type: :controller do
  describe "GET #index.json" do
    it "should render Congress.bioguide_map as json" do
      expect(Congress::Member).to receive(:bioguide_map){ { bioguide_id: { name: "xyz" } } }
      get :index, format: :json

      expect(response.content_type).to eq("application/json")
      expect(JSON.load(response.body)).to eq({ "bioguide_id" => { "name" => "xyz" } })
    end
  end
end
