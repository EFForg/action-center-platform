require "rails_helper"

describe SourceFile do
  # TODO: mocking failing in CI and resulting in real requests, fix
  context "methods that do not require image processing" do
    let(:generated_part) { "subfolder12345-67890" }
    let(:file_name) { "image.png" }
    let(:folder) { "uploads" }
    let(:full_key) { [folder, generated_part, file_name].join("/") }
    describe "#generated_key_part" do
      xit "returns the key without folder name or file name" do
        file = FactoryBot.create(:source_file, key: full_key)
        expect(file.generated_key_part).to eq(generated_part)
      end
    end
    describe "#key_without_file_name" do
      xit "does not include the filename" do
        file = FactoryBot.create(:source_file, key: full_key)
        expect(file.key_without_file_name).to \
          eq([folder, generated_part].join("/"))
      end
    end
  end
end
