require "rails_helper"

RSpec.describe "Action Pages", type: :request do
  describe "small petition" do
    before(:each) do
      @action_page = FactoryBot.create(:petition_with_99_signatures_needing_1_more).action_page
    end

    it "lists action pages" do
      get "/action"

      expect(response).to render_template(:index)
      expect(response.body).to include(@action_page.title)
    end

    it "should allow cors wildcard for broad web consumption" do
      get "/action"

      cors_wildcard_presence = response.headers.any? do |k, v|
        k == "Access-Control-Allow-Origin" && v == "*"
      end
      expect(cors_wildcard_presence).to be_truthy
    end
  end

  describe "large petition" do
    it "should present the count of signatures" do
      @action_page = FactoryBot.create(:petition_complete_with_one_thousand_signatures).action_page

      path = "#{action_page_path(@action_page)}/signature_count"
      get path

      expect(response.body).to eq "1000"
    end
  end

  describe "json" do
    it "returns json" do
      FactoryBot.create(:action_page)
      get "/action.json"
      expect(response.code).to eq "200"
      expect(response.parsed_body).to include(a_hash_including({ "title" => "Sample Action Page" }))
    end

    it "returns image attributes in json" do
      file_name = "test-image.png"
      content_type = "image/png"
      url_pattern = %r{/action_pages/featured_images/([0-9]+)/([0-9]+)/([0-9]+)/original/#{file_name}}
      StorageHelpers.unmock_and_stub!(url_pattern,
                                      status: 200,
                                      body: file_fixture(file_name).read,
                                      headers: { content_type: content_type })
      FactoryBot.create(:action_page, :with_image,
                        type: :featured,
                        file_name: file_name,
                        content_type: "image/png")

      get "/action.json"

      expected = {
        "title" => "Sample Action Page",
        "featured_image" => {
          "alt" => file_name.titleize,
          "url" => a_string_matching(url_pattern)
        }
      }
      expect(response.code).to eq "200"
      expect(response.parsed_body.first).to include(**expected)
    end
  end

  describe "atom" do
    it "returns atom" do
      FactoryBot.create(:action_page)
      get "/action.atom"
      expect(response.code).to eq "200"
      expect(response.body).to match("Sample Action Page")
    end

    it "returns image attributes in atom" do
      file_name = "test-image.png"
      content_type = "image/png"
      url_pattern = %r{/action_pages/featured_images/([0-9]+)/([0-9]+)/([0-9]+)/original/#{file_name}}
      StorageHelpers.unmock_and_stub!(url_pattern,
                                      status: 200,
                                      body: file_fixture(file_name).read,
                                      headers: { content_type: content_type })
      FactoryBot.create(:action_page, :with_image,
                        type: :featured,
                        file_name: file_name,
                        content_type: content_type)

      get "/action.atom"
      expect(response.code).to eq "200"
      expect(response.body).to match("Sample Action Page")
      expect(response.body).to match(url_pattern)
    end
  end
end
