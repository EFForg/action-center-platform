class Twitter
  def self.has_api_keys?
    !Rails.application.secrets.twitter_api_key.blank? &&
      !Rails.application.secrets.twitter_api_secret.blank? &&
      !Rails.application.secrets.twitter_oauth_token.blank? &&
      !Rails.application.secrets.twitter_oauth_token_secret.blank?
  end

  # ref: https://dev.twitter.com/oauth/overview/single-user
  def self.prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(
        Rails.application.secrets.twitter_api_key,
        Rails.application.secrets.twitter_api_secret,
        { site: "https://api.twitter.com", scheme: :header })

    # now create the access token object from passed values
    token_hash = { oauth_token: oauth_token,
                   oauth_token_secret: oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  end
end
