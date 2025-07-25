class Twitter
  def self.has_api_keys?
    Rails.application.secrets.twitter_api_key.present? &&
      Rails.application.secrets.twitter_api_secret.present? &&
      Rails.application.secrets.twitter_oauth_token.present? &&
      Rails.application.secrets.twitter_oauth_token_secret.present?
  end

  # ref: https://dev.twitter.com/oauth/overview/single-user
  def self.prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(
      Rails.application.secrets.twitter_api_key,
      Rails.application.secrets.twitter_api_secret,
      { site: "https://api.twitter.com", scheme: :header }
    )

    # now create the access token object from passed values
    token_hash = { oauth_token: oauth_token,
                   oauth_token_secret: oauth_token_secret }
    OAuth::AccessToken.from_hash(consumer, token_hash)
  end
end
