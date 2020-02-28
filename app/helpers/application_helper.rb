module ApplicationHelper
  def page_title
    t("page_title", scope: [controller_path.gsub("/", "_"), action_name],
      default: [@title, I18n.t("site_title")].compact.join(" | "))
  end

  def escape_page_title
    URI.escape(page_title , Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def twitter_handle
    "@" + Rails.application.config.twitter_handle.to_s
  end

  def markdown(blogtext)
    blogtext = substitute_keywords(blogtext)
    renderOptions = { hard_wrap: true, filter_html: false }
    markdownOptions = { autolink: true, no_intra_emphasis: true, fenced_code_blocks: true }
    markdown = Redcarpet::Markdown.new(MarkdownRenderer.new(renderOptions), markdownOptions)
    markdown.render(blogtext).html_safe # rubocop:disable Rails/OutputSafety
  end

  def substitute_keywords(blogtext)
    if @actionPage and @actionPage.description and @petition
      blogtext.gsub("$SIGNATURECOUNT", @petition.signatures.pretty_count)
    else
      blogtext
    end
  end

  def stripdown(str)
    require "redcarpet/render_strip"
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    renderer.render(str)
  end

  def current_email
    current_user_data(:email)
  end

  def current_first_name
    current_user_data(:first_name)
  end

  def current_last_name
    current_user_data(:last_name)
  end

  def current_street_address
    current_user_data(:street_address)
  end

  def current_city
    current_user_data(:city)
  end

  def current_state
    current_user_data(:state)
  end

  def current_zipcode
    current_user_data(:zipcode)
  end

  def current_country_code
    current_user_data(:country_code)
  end

  def update_user_data(params = {})
    params = params.slice(*user_session_data_whitelist)
    if user_signed_in?
      p = params.clone
      p.delete(:email)
      current_user.update_attributes p
    end
  end

  def sanitize_filename(filename)
    # Split the name when finding a period which is preceded by some
    # character, and is followed by some character other than a period,
    # if there is no following period that is followed by something
    # other than a period (yeah, confusing, I know)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

    # We now have one or two parts (depending on whether we could find
    # a suitable period). For each of these parts, replace any unwanted
    # sequence of characters with an underscore
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, "_" }

    # Finally, join the parts with a period and return the result
    return fn.join "."
  end

  def can?(ability)
    current_user.try(:can?, ability)
  end

  def pluralize_with_span(count, noun)
    noun = count == 1 ? noun : noun.pluralize
    content_tag(:span, count) + " #{noun}"
  end

  def messages
    messages = flash.collect do |type, content|
      content_tag :p, content, class: "flash #{type}"
    end

    safe_join(messages)
  end

  def percentage(x, y, precision: 0)
    return "-" unless y > 0
    number_to_percentage((x / y.to_f) * 100, precision: precision)
  end

  private

  def user_session_data_whitelist
    [:email, :last_name, :first_name, :street_address, :city, :state, :zipcode,
     :country_code, :phone]
  end

  def current_user_data(field)
    return nil unless user_session_data_whitelist.include? field
    current_user.try(field)
  end
end
