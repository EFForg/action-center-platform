module ApplicationHelper
  def page_title
    [@title, I18n.t('site_title')].compact.join(' | ')
  end

  def escape_page_title
    URI.escape(page_title , Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def twitter_handle
    '@' + Rails.application.config.twitter_handle.to_s
  end

  def markdown(blogtext)
    blogtext = substitute_keywords(blogtext)
    renderOptions = {hard_wrap: true, filter_html: false}
    markdownOptions = {autolink: true, no_intra_emphasis: true, fenced_code_blocks: true}
    markdown = Redcarpet::Markdown.new(MarkdownRenderer.new(renderOptions), markdownOptions)
    markdown.render(blogtext).html_safe
  end

  def substitute_keywords(blogtext)
    if @actionPage and @actionPage.description and @petition
      blogtext.gsub('$SIGNATURECOUNT', @petition.signatures.pretty_count)
    else
      blogtext
    end
  end

  def stripdown(str)
    require 'redcarpet/render_strip'
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    renderer.render(str)
  end

  def country_codes
    [
        ["Afghanistan", "AF"],
        ["Aland Islands", "AX"],
        ["Albania", "AL"],
        ["Algeria", "DZ"],
        ["American Samoa", "AS"],
        ["Andorra", "AD"],
        ["Angola", "AO"],
        ["Anguilla", "AI"],
        ["Antarctica", "AQ"],
        ["Antigua and Barbuda", "AG"],
        ["Argentina", "AR"],
        ["Armenia", "AM"],
        ["Aruba", "AW"],
        ["Ascension Island", "AC"],
        ["Australia", "AU"],
        ["Austria", "AT"],
        ["Azerbaijan", "AZ"],
        ["Bahamas", "BS"],
        ["Bahrain", "BH"],
        ["Bangladesh", "BD"],
        ["Barbados", "BB"],
        ["Belarus", "BY"],
        ["Belgium", "BE"],
        ["Belize", "BZ"],
        ["Benin", "BJ"],
        ["Bermuda", "BM"],
        ["Bhutan", "BT"],
        ["Bolivia, Plurinational State of", "BO"],
        ["Bonaire, Sint Eustatius and Saba", "BQ"],
        ["Bosnia and Herzegovina", "BA"],
        ["Botswana", "BW"],
        ["Bouvet Island", "BV"],
        ["Brazil", "BR"],
        ["British Indian Ocean Territory", "IO"],
        ["Brunei Darussalam", "BN"],
        ["Bulgaria", "BG"],
        ["Burkina Faso", "BF"],
        ["Burundi", "BI"],
        ["Cambodia", "KH"],
        ["Cameroon", "CM"],
        ["Canada", "CA"],
        ["Cape Verde", "CV"],
        ["Cayman Islands", "KY"],
        ["Central African Republic", "CF"],
        ["Chad", "TD"],
        ["Chile", "CL"],
        ["China", "CN"],
        ["Christmas Island", "CX"],
        ["Cocos (Keeling) Islands", "CC"],
        ["Colombia", "CO"],
        ["Comoros", "KM"],
        ["Congo", "CG"],
        ["Congo, the Democratic Republic of the", "CD"],
        ["Cook Islands", "CK"],
        ["Costa Rica", "CR"],
        ["Cote d'Ivoire", "CI"],
        ["Croatia", "HR"],
        ["Cuba", "CU"],
        ["Curacao", "CW"],
        ["Cyprus", "CY"],
        ["Czech Republic", "CZ"],
        ["Denmark", "DK"],
        ["Djibouti", "DJ"],
        ["Dominica", "DM"],
        ["Dominican Republic", "DO"],
        ["Ecuador", "EC"],
        ["Egypt", "EG"],
        ["El Salvador", "SV"],
        ["Equatorial Guinea", "GQ"],
        ["Eritrea", "ER"],
        ["Estonia", "EE"],
        ["Ethiopia", "ET"],
        ["Falkland Islands (Malvinas)", "FK"],
        ["Faroe Islands", "FO"],
        ["Fiji", "FJ"],
        ["Finland", "FI"],
        ["France", "FR"],
        ["French Guiana", "GF"],
        ["French Polynesia", "PF"],
        ["French Southern Territories", "TF"],
        ["Gabon", "GA"],
        ["Gambia", "GM"],
        ["Georgia", "GE"],
        ["Germany", "DE"],
        ["Ghana", "GH"],
        ["Gibraltar", "GI"],
        ["Greece", "GR"],
        ["Greenland", "GL"],
        ["Grenada", "GD"],
        ["Guadeloupe", "GP"],
        ["Guam", "GU"],
        ["Guatemala", "GT"],
        ["Guernsey", "GG"],
        ["Guinea", "GN"],
        ["Guinea-Bissau", "GW"],
        ["Guyana", "GY"],
        ["Haiti", "HT"],
        ["Heard Island and McDonald Islands", "HM"],
        ["Holy See (Vatican City State)", "VA"],
        ["Honduras", "HN"],
        ["Hong Kong", "HK"],
        ["Hungary", "HU"],
        ["Iceland", "IS"],
        ["India", "IN"],
        ["Indonesia", "ID"],
        ["Iran, Islamic Republic of", "IR"],
        ["Iraq", "IQ"],
        ["Ireland", "IE"],
        ["Isle of Man", "IM"],
        ["Israel", "IL"],
        ["Italy", "IT"],
        ["Jamaica", "JM"],
        ["Japan", "JP"],
        ["Jersey", "JE"],
        ["Jordan", "JO"],
        ["Kazakhstan", "KZ"],
        ["Kenya", "KE"],
        ["Kiribati", "KI"],
        ["Korea, Democratic People's Republic of", "KP"],
        ["Korea, Republic of", "KR"],
        ["Kosovo", "KV"],
        ["Kuwait", "KW"],
        ["Kyrgyzstan", "KG"],
        ["Lao People's Democratic Republic", "LA"],
        ["Latvia", "LV"],
        ["Lebanon", "LB"],
        ["Lesotho", "LS"],
        ["Liberia", "LR"],
        ["Libya", "LY"],
        ["Liechtenstein", "LI"],
        ["Lithuania", "LT"],
        ["Luxembourg", "LU"],
        ["Macao", "MO"],
        ["Macedonia, The Former Yugoslav Republic Of", "MK"],
        ["Madagascar", "MG"],
        ["Malawi", "MW"],
        ["Malaysia", "MY"],
        ["Maldives", "MV"],
        ["Mali", "ML"],
        ["Malta", "MT"],
        ["Marshall Islands", "MH"],
        ["Martinique", "MQ"],
        ["Mauritania", "MR"],
        ["Mauritius", "MU"],
        ["Mayotte", "YT"],
        ["Mexico", "MX"],
        ["Micronesia, Federated States of", "FM"],
        ["Moldova, Republic of", "MD"],
        ["Monaco", "MC"],
        ["Mongolia", "MN"],
        ["Montenegro", "ME"],
        ["Montserrat", "MS"],
        ["Morocco", "MA"],
        ["Mozambique", "MZ"],
        ["Myanmar", "MM"],
        ["Namibia", "NA"],
        ["Nauru", "NR"],
        ["Nepal", "NP"],
        ["Netherlands", "NL"],
        ["Netherlands Antilles", "AN"],
        ["New Caledonia", "NC"],
        ["New Zealand", "NZ"],
        ["Nicaragua", "NI"],
        ["Niger", "NE"],
        ["Nigeria", "NG"],
        ["Niue", "NU"],
        ["Norfolk Island", "NF"],
        ["Northern Mariana Islands", "MP"],
        ["Norway", "NO"],
        ["Oman", "OM"],
        ["Pakistan", "PK"],
        ["Palau", "PW"],
        ["Palestinian Territory, Occupied", "PS"],
        ["Panama", "PA"],
        ["Papua New Guinea", "PG"],
        ["Paraguay", "PY"],
        ["Peru", "PE"],
        ["Philippines", "PH"],
        ["Pitcairn", "PN"],
        ["Poland", "PL"],
        ["Portugal", "PT"],
        ["Puerto Rico", "PR"],
        ["Qatar", "QA"],
        ["Reunion", "RE"],
        ["Romania", "RO"],
        ["Russian Federation", "RU"],
        ["Rwanda", "RW"],
        ["Saint Barthelemy", "BL"],
        ["Saint Helena, Ascension and Tristan da Cunha", "SH"],
        ["Saint Kitts and Nevis", "KN"],
        ["Saint Lucia", "LC"],
        ["Saint Martin (French part)", "MF"],
        ["Saint Pierre and Miquelon", "PM"],
        ["Saint Vincent and the Grenadines", "VC"],
        ["Samoa", "WS"],
        ["San Marino", "SM"],
        ["Sao Tome and Principe", "ST"],
        ["Saudi Arabia", "SA"],
        ["Senegal", "SN"],
        ["Serbia", "RS"],
        ["Seychelles", "SC"],
        ["Sierra Leone", "SL"],
        ["Singapore", "SG"],
        ["Sint Maarten (Dutch part)", "SX"],
        ["Slovakia", "SK"],
        ["Slovenia", "SI"],
        ["Solomon Islands", "SB"],
        ["Somalia", "SO"],
        ["South Africa", "ZA"],
        ["South Georgia and the South Sandwich Islands", "GS"],
        ["South Sudan, Republic of", "SS"],
        ["Spain", "ES"],
        ["Sri Lanka", "LK"],
        ["Sudan", "SD"],
        ["Suriname", "SR"],
        ["Svalbard and Jan Mayen", "SJ"],
        ["Swaziland", "SZ"],
        ["Sweden", "SE"],
        ["Switzerland", "CH"],
        ["Syrian Arab Republic", "SY"],
        ["Taiwan", "TW"],
        ["Tajikistan", "TJ"],
        ["Tanzania, United Republic of", "TZ"],
        ["Thailand", "TH"],
        ["Timor-Leste", "TL"],
        ["Togo", "TG"],
        ["Tokelau", "TK"],
        ["Tonga", "TO"],
        ["Trinidad and Tobago", "TT"],
        ["Tristan da Cunha", "TA"],
        ["Tunisia", "TN"],
        ["Turkey", "TR"],
        ["Turkmenistan", "TM"],
        ["Turks and Caicos Islands", "TC"],
        ["Tuvalu", "TV"],
        ["Uganda", "UG"],
        ["Ukraine", "UA"],
        ["United Arab Emirates", "AE"],
        ["United Kingdom", "GB"],
        ["United States", "US"],
        ["United States Minor Outlying Islands", "UM"],
        ["Uruguay", "UY"],
        ["Uzbekistan", "UZ"],
        ["Vanuatu", "VU"],
        ["Venezuela, Bolivarian Republic of", "VE"],
        ["Viet Nam", "VN"],
        ["Virgin Islands, British", "VG"],
        ["Virgin Islands, U.S.", "VI"],
        ["Wallis and Futuna", "WF"],
        ["Western Sahara", "EH"],
        ["Yemen", "YE"],
        ["Zambia", "ZM"],
        ["Zimbabwe", "ZW"]
      ]
  end

  def us_states_hash
    {
      "Alabama"=>"AL",
      "Alaska"=>"AK",
      "American Samoa"=>"AS",
      "Arizona"=>"AZ",
      "Arkansas"=>"AR",
      "California"=>"CA",
      "Colorado"=>"CO",
      "Connecticut"=>"CT",
      "Delaware"=>"DE",
      "District of Columbia"=>"DC",
      "Florida"=>"FL",
      "Georgia"=>"GA",
      "Guam"=>"GU",
      "Hawaii"=>"HI",
      "Idaho"=>"ID",
      "Illinois"=>"IL",
      "Indiana"=>"IN",
      "Iowa"=>"IA",
      "Kansas"=>"KS",
      "Kentucky"=>"KY",
      "Louisiana"=>"LA",
      "Maine"=>"ME",
      "Maryland"=>"MD",
      "Massachusetts"=>"MA",
      "Michigan"=>"MI",
      "Minnesota"=>"MN",
      "Mississippi"=>"MS",
      "Missouri"=>"MO",
      "Montana"=>"MT",
      "Nebraska"=>"NE",
      "Nevada"=>"NV",
      "New Hampshire"=>"NH",
      "New Jersey"=>"NJ",
      "New Mexico"=>"NM",
      "New York"=>"NY",
      "North Carolina"=>"NC",
      "North Dakota"=>"ND",
      "Northern Mariana Islands"=>"MP",
      "Ohio"=>"OH",
      "Oklahoma"=>"OK",
      "Oregon"=>"OR",
      "Pennsylvania"=>"PA",
      "Puerto Rico"=>"PR",
      "Rhode Island"=>"RI",
      "South Carolina"=>"SC",
      "South Dakota"=>"SD",
      "Tennessee"=>"TN",
      "Texas"=>"TX",
      "Utah"=>"UT",
      "Vermont"=>"VT",
      "Virgin Islands"=>"VI",
      "Virginia"=>"VA",
      "Washington"=>"WA",
      "West Virginia"=>"WV",
      "Wisconsin"=>"WI",
      "Wyoming"=>"WY"
    }
  end

  def us_states
    us_states_hash.to_a
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

  def congress_forms_date_fills_url campaign_tag = nil, date_start = nil, date_end = nil, bioguide_id = nil
    url = Rails.application.config.congress_forms_url + '/successful-fills-by-date/'
    url = url + bioguide_id unless bioguide_id.nil?
    params = {
      :campaign_tag => campaign_tag,
      :time_zone => Time.zone.name,
      :give_as_utc => true,
      :debug_key => Rails.application.secrets.congress_forms_debug_key,
      :date_start => date_start,
      :date_end => date_end
    }
    params.reject! { |_, v| v.to_param.nil? }
    url << "?#{params.to_query}"
  end

  def congress_forms_hour_fills_url campaign_tag = nil, date = nil, bioguide_id = nil
    url = Rails.application.config.congress_forms_url + '/successful-fills-by-hour/'
    url = url + bioguide_id unless bioguide_id.nil?
    params = {
      :campaign_tag => campaign_tag,
      :time_zone => Time.zone.name,
      :give_as_utc => true,
      :debug_key => Rails.application.secrets.congress_forms_debug_key,
      :date => date.strftime('%Y-%m-%d')
    }
    params.reject! { |_, v| v.to_param.nil? }
    url << "?#{params.to_query}"
  end

  def congress_forms_member_fills_url campaign_tag = nil
    url = Rails.application.config.congress_forms_url + '/successful-fills-by-member/'
    params = {
      :campaign_tag => campaign_tag,
      :debug_key => Rails.application.secrets.congress_forms_debug_key
    }
    params.reject! { |_, v| v.to_param.nil? }
    url << "?#{params.to_query}"
  end

  def update_user_data(params={})
    params = params.with_indifferent_access.slice(*user_session_data_whitelist)
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
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

    # Finally, join the parts with a period and return the result
    return fn.join '.'
  end

  def can?(ability)
    current_user.try(:can?, ability)
  end

  def pluralize_with_span(count, noun)
    noun = if count == 1 then noun else noun.pluralize end
    content_tag(:span, count) + " #{noun}"
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
