require "rest_client"

module CongressForms
  class Form
    attr_accessor :fields, :bioguide_id

    def self.find(bioguide_ids)
      raw_data = CongressForms.post("/retrieve-form-elements/", { bio_ids: bioguide_ids })
      raise CongressForms::RequestFailed if raw_data.empty?
      links, forms = raw_data.partition { |id, raw| raw["defunct"] }
      [
        forms.map { |id, raw| Form.new(id, raw["required_actions"]) },
        links.map { |id, raw| [id, raw["contact_url"]] }.to_h
      ]
    end

    def initialize(bioguide_id, fields)
      @bioguide_id = bioguide_id
      @fields = fields.map { |f| Field.new(f) }
      order_fields
    end

    def order_fields
      order = %w($NAME_PREFIX $NAME_FIRST $NAME_LAST $PHONE $EMAIL $SUBJECT $TOPIC)
      @fields = @fields.sort_by { |f| order.index(f.value) || Float::INFINITY }
    end

    def fill(input, campaign_tag, test = false)
      params = { bio_id: @bioguide_id, campaign_tag: campaign_tag, fields: input }
      params[:test] = 1 if test
      CongressForms.post("/fill-out-form/", params)
    end
  end

  class Field
    attr_reader :max_length, :value
    attr_writer :options_hash

    def initialize(opts)
      @max_length = opts["max_length"]
      @value = opts["value"]
      @options_hash = opts["options_hash"]
    end

    def validate(input)
      return false if input.nil?
      return false if max_length && input.length > max_length
      return false unless options.nil? || options.include?(input)
      true
    end

    def label
      I18n.t value, scope: :congress_forms, default: value.sub("$", "").humanize
    end

    def is_select?
      options_hash != nil
    end

    def ==(other)
      max_length == other.max_length &&
        value == other.value &&
        options_hash == other.options_hash
    end

    def eql?(other)
      self == other
    end

    def hash
      [max_length, value, options_hash].hash
    end

    def options_hash
      if @value == "$ADDRESS_STATE_POSTAL_ABBREV"
        Places.us_state_codes
      elsif @value == "$ADDRESS_STATE_FULL"
        Places.us_states
      else
        @options_hash
      end
    end

    def options
      return options_hash.values if options_hash.is_a?(Hash)
      options_hash
    end
  end

  def self.member_fills_url(campaign_tag)
    base_url + data_path("/successful-fills-by-member/", { campaign_tag: campaign_tag })
  end

  def self.date_fills_path(campaign_tag = nil, start_date = nil, end_date = nil, bioguide_id = nil)
    params = {
      date_start: start_date,
      date_end: end_date,
      campaign_tag: campaign_tag,
    }.compact
    data_path("/successful-fills-by-date/", params, bioguide_id)
  end

  def self.date_fills_url(*args)
    base_url + date_fills_path(*args)
  end

  def self.date_fills(*args)
    get date_fills_path(*args)
  end

  def self.data_path(base_path, params = {}, bioguide_id = nil)
    base_path += bioguide_id unless bioguide_id.nil?
    base_path += "?" + {
      debug_key: Rails.application.secrets.congress_forms_debug_key,
    }.merge(params).to_query
  end

  def self.get(path)
    begin
      JSON.parse RestClient.get(base_url + path)
    rescue RestClient::ExceptionWithResponse => e
      Raven.capture_exception(e)
      Rails.logger.error e
      return {}
    end
  end

  def self.post(path, body = {})
    begin
      JSON.parse RestClient.post(base_url + path, body.to_json,
                                 { content_type: :json, accept: :json })
    rescue RestClient::ExceptionWithResponse => e
      Raven.capture_exception(e)
      Rails.logger.error e
      raise RequestFailed
    end
  end

  def self.base_url
    Rails.application.config.congress_forms_url
  end

  class RequestFailed < RestClient::ExceptionWithResponse; end
end
