module S3UploadHelper
  def s3_presigned_post_fields
    @s3_direct_post.fields.map do |key, value|
      { name: key, value: value }
    end.to_json
  end
end
