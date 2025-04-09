require "rails_helper"

RSpec.describe RelatedContent do
  let(:stub_url) { "https://eff.org" }
  let(:action_page) do
    FactoryBot.create(:action_page, related_content_url: stub_url)
  end
  # these values are from the fixture
  let(:og_image_url) { "https://www.eff.org/files/banner_library/robotai.png" }
  let(:title) do
    "California’s A.B. 412: A Bill That Could Crush Startups and Cement A "\
      "Big Tech AI Monopoly"
  end
  subject { described_class.new(stub_url) }

  before do
    deeplink = file_fixture("deeplink.html").read
    stub_request(:any, stub_url).to_return(body: deeplink)
  end

  describe "#load" do
    it "fetches the html from the given URL" do
      described_class.new(stub_url).load
      expect(WebMock).to have_requested(:get, stub_url)
    end
  end

  describe "#as_hash" do
    it "returns the title and image url of the blogpost" do
      expect(subject.as_hash).to eq({ title: title, image_url: og_image_url })
    end
  end

  context "data methods" do
    before { subject.load }
    describe "#title" do
      it "returns the blogpost title" do
        expect(subject.title).to eq(title)
      end
    end

    describe "#image" do
      it "returns the blogpost og image url" do
        expect(subject.image).to eq(og_image_url)
      end
    end
  end
end
