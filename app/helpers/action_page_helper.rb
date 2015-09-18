module ActionPageHelper
  def twitter_share_url(action_page)
    message = [
      action_page.share_message, action_page_url(action_page)
    ].map(&:presence).compact.join(' ')

    suffix = if Rails.application.config.twitter_handle
               " via @#{Rails.application.config.twitter_handle}"
             end
    message += suffix if action_page.share_message.to_s.length + suffix.length <= 117


    related = Rails.application.config.twitter_related.to_a.join(',')

    "https://twitter.com/intent/tweet?status=#{CGI::escape message}&related=#{related}"
  end

  def google_share_url(action_page)
    "https://plus.google.com/share?url=#{action_page_url(action_page)}"
  end

  def tweet_url(target, message)
    target = "@#{target}" unless target.starts_with? '@'
    message = [target, message].compact.join(' ')
    related = Rails.application.config.twitter_related.to_a.join(',')
    "https://twitter.com/intent/tweet?status=.#{CGI::escape message}&related=#{related}"
  end

  def facebook_share_url(action_page)
    "https://www.facebook.com/sharer/sharer.php?app_id=97703891945&u=#{action_page_url(action_page)}&display=popup"
  end

  def email_friends_url(action_page)
    subject = t('email_friends.subject')
    message = t('email_friends.message', title: action_page.title, url: action_page_url(action_page))

    "mailto:?subject=#{CGI::escape subject}&body=#{CGI::escape message}"
  end

  def rep_photo_src(bioguide_id)
    asset_path "congress-images-102x125/i/#{bioguide_id}.jpg"
  end

  def rep_tweet_link(rep)
    tweet_link("@#{rep.twitter_id}", class: 'btn-sm rep')
  end

  def individual_tweet_link(tweet_target)
    tweet_link(tweet_target.twitter_id, class: :individual)
  end

  def tweet_link(twitter_id, params={})
    twitter_id = "@#{twitter_id}" unless twitter_id.to_s.starts_with? '@'
    link_to raw("<i class='icon-twitter-1'></i> Tweet #{twitter_id}"),
            tweet_url(twitter_id, @tweet.try(:message)),
            class: "btn btn-tweet btn-default #{params[:class]}",
            data: { twitter_id: twitter_id },
            target: :blank
  end

  def tweet_tool_classes
    classes = []
    classes << 'house' if @actionPage.tweet.target_house?
    classes << 'senate' if @actionPage.tweet.target_senate?
    classes.join(' ')
  end

  def parse_email_text(options={})
    email_text = @actionPage.email_text

    url = action_page_url(@actionPage)
    title = @actionPage.title
    name = options[:name] || "Friend of Digital Freedom"

    email_text.
      gsub(/\$TITLE/, title).
      gsub(/\$URL/, url).
      gsub(/\$NAME/, name)
  end
end
