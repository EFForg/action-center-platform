module S3UploadHelper
  def s3_presigned_post_fields
    s3_direct_post = S3_BUCKET.presigned_post(
      key: "uploads/#{SecureRandom.uuid}/${filename}",
      success_action_status: "201", acl: "public-read"
    )

    s3_direct_post.fields.map do |key, value|
      { name: key, value: value }
    end.to_json
  end
end
