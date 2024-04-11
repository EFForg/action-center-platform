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

  before(:each) do
    # bypasses a 3rd party lookup (s3)
    allow_any_instance_of(SourceFile).to receive(:pull_down_s3_object_attributes).and_return(true)
  end

  it "should deny non-admins" do
    expect do
      post "/admin/source_files", params: valid_attributes
    end.to raise_exception(ActiveRecord::RecordNotFound)
  end

  it "should allow admins" do
    @admin = FactoryBot.create(:admin_user)
    login @admin

    expect do
      post "/admin/source_files", params: valid_attributes
    end.to change { SourceFile.count }.by(1)
  end

  it "should have valid response" do
    @admin = FactoryBot.create(:admin_user)
    login @admin

    post "/admin/source_files", params: valid_attributes

    expect(response.parsed_body).to include(
      "id" => 1,
      "delete_url" => "/admin/source_files/1.json",
      "full_url" => a_string_matching(%r{/uploads/3be325f2b4e64d9d92a89405577280a4/img.png}),
      "image" => true,
      "name" => "img.png",
      "size" => 10
    )
  end
end
