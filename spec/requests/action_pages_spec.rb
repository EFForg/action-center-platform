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
      stub_request(:get, %r{fakeimages/test.png}).to_return(status: 200, body: fixture_file_upload("test-image.png", "image/png").tempfile.to_io, headers: { content_type: "image/png" })
      stub_request(:any, %r{/action_pages/featured_images/([0-9]+)/([0-9]+)/([0-9]+)/original/test.png}).to_return(status: 200, body: "", headers: {})
      FactoryBot.create(:action_page, remote_featured_image_url: "https://example.com/fakeimages/test.png")

      get "/action.json"
      expect(response.code).to eq "200"
      expect(response.parsed_body).to include(a_hash_including({
        "title" => "Sample Action Page",
        "featured_image" => a_hash_including({
          "alt" => "Test.Png",
          "url" => a_string_matching(%r{/action_pages/featured_images/([0-9]+)/([0-9]+)/([0-9]+)/original/test.png})
        })
      }))
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
      allow_any_instance_of(ActionPageImageUploader).to receive(:content_type).and_return("image/png")
      stub_request(:get, %r{fakeimages/test.png}).to_return(status: 200, body: file_fixture("test-image.png").read, headers: { content_type: "image/png" })
      stub_request(:any, %r{/action_pages/featured_images/([0-9]+)/([0-9]+)/([0-9]+)/original/test.png}).to_return(status: 200, body: file_fixture("test-image.png").read, headers: { content_type: "image/png" })
      FactoryBot.create(:action_page, remote_featured_image_url: "https://example.com/fakeimages/test.png")

      get "/action.atom"
      expect(response.code).to eq "200"
      expect(response.body).to match("Sample Action Page")
      expect(response.body).to match(%r{/action_pages/featured_images/([0-9]+)/([0-9]+)/([0-9]+)/original/test.png})
    end
  end
end
