require "rails_helper"

RSpec.describe Paperclip::MediaTypeSpoofDetector do
  let(:img_file) { "test-image.png" }
  let(:csv) { "schools.csv" }
  it "passes for good png files" do
    detector = described_class.new(File.open(file_fixture(img_file)), img_file,
                                   "image/png")
    expect(detector.spoofed?).to eq(false)
  end

  it "passes for png files when the header is 'binary/octet-stream'" do
    detector = described_class.new(File.open(file_fixture(img_file)), img_file,
                                   "binary/octet-stream")
    expect(detector.spoofed?).to eq(false)
  end

  it "fails when headers are 'binary/octet-stream' and not an image" do
    detector = described_class.new(File.open(file_fixture(csv)), csv,
                                   "binary/octet-stream")
    expect(detector.spoofed?).to eq(true)
  end

  it "fails for non-images" do
    detector = described_class.new(File.open(file_fixture(csv)), csv,
                                   "text/csv")
    expect(detector.spoofed?).to eq(true)
  end
end
