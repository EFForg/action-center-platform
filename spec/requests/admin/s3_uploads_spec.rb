require "rails_helper"

RSpec.describe "S3 Uploads Spec", type: :request do
  let(:valid_attributes) do
    {
      "source_file" => {
        "bucket" => "actioncenter-staging",
        "file_name" => "img.png",
        "file_content_type" => "image",
        "file_size" => "10",
        "key" => "uploads/3be325f2b4e64d9d92a89405577280a4/img.png"
      },
      "action" => "create",
      "controller" => "admin/s3_uploads",
      "format" => "json"
    }
  end

  it "should deny non-admins" do
    expect do
      post "/admin/source_files", params: valid_attributes
    end.to raise_exception(ActiveRecord::RecordNotFound)
  end

  it "should allow admins" do
    sign_in FactoryBot.create(:admin_user)

    expect do
      post "/admin/source_files", params: valid_attributes
    end.to change { SourceFile.count }.by(1)
  end

  it "should have valid response" do
    sign_in FactoryBot.create(:admin_user)

    post "/admin/source_files", params: valid_attributes

    expect(response.parsed_body).to include(
      "delete_url" => a_string_matching(%r{/admin/source_files/[0-9]+.json}),
      "full_url" => a_string_matching(%r{/uploads/3be325f2b4e64d9d92a89405577280a4/img.png}),
      "image" => true,
      "name" => "img.png",
      "size" => 10
    )
  end
end
