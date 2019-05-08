class TweetTarget < ActiveRecord::Base
  extend AmazonCredentials
  require "open-uri"

  belongs_to :tweet
  has_attached_file :image, amazon_credentials
  validates_media_type_spoof_detection :image, if: ->() { image_file_name.present? }
  do_not_validate_attachment_file_type :image
  after_save :attach_twitter_image

  def url
    "https://twitter.com/" + twitter_id
  end

  def image_url
    image.url
  end

  def attach_twitter_image
    self.delay.attach_twitter_image_without_delay if image_file_name.nil? and Twitter.has_api_keys?
  end

  def attach_twitter_image_without_delay
    access_token = Twitter.prepare_access_token Rails.application.secrets.twitter_oauth_token, Rails.application.secrets.twitter_oauth_token_secret

    # ref: https://dev.twitter.com/overview/general/user-profile-images-and-banners
    response = access_token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=" + twitter_id)
    user_info = JSON.parse response.body
    user_image_url = user_info["profile_image_url_https"].gsub(/_normal\./, "_bigger.")

    self.image = URI.parse(user_image_url)
    self.save
  end
end
