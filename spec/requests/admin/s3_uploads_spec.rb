require "rails_helper"

RSpec.describe "S3 Uploads Spec", type: :request do
  let(:valid_attributes) { {
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
  } }

  before(:each) do
    # bypasses a 3rd party lookup (s3)
    allow_any_instance_of(SourceFile).to receive(:pull_down_s3_object_attributes).and_return(true)
  end

  it "should deny non-admins" do
    expect {
      post "/admin/source_files", params: valid_attributes
    }.to raise_exception(ActiveRecord::RecordNotFound)
  end

  it "should allow admins" do
    @admin = FactoryGirl.create(:admin_user)
    login @admin

    expect {
      post "/admin/source_files", params: valid_attributes
    }.to change { SourceFile.count }.by(1)
  end
end
