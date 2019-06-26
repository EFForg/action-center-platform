require "rest_client"

module CongressForms
  class Form
    attr_accessor :fields, :bioguide_id

    EXTRA_INPUTS = %w($MESSAGE).freeze

    def self.find(bioguide_ids)
      raw_forms = CongressForms.post("/retrieve-form-elements/", {
        bio_ids: bioguide_ids
      })
      raw_forms.map { |id, raw| Form.new(id, raw["required_actions"]) }
    end

    def self.common_fields(forms)
      all_fields = forms.reduce([]) { |a, b| a + b.fields }
      all_fields.select { |e| all_fields.count(e) > 1 }.uniq
    end

    def initialize(bioguide_id, fields)
      @bioguide_id = bioguide_id
      @fields = fields.map { |f| Field.new(f) }
    end

    def validate(input)
      @fields.each do |f|
        return false unless f.validate(input[f.value])
      end
      true
    end

    def fill(input)
      field_vals = @fields.map { |f| f.value } + EXTRA_INPUTS
      params = {
        bioguide_id: @bioguide_id,
        fields: input.select { |k, v| field_vals.include?(k) }
      }
      CongressForms.post("/fill-out-form/", params)
    end
  end

  class Field
    attr_accessor :max_length, :value, :options_hash

    def initialize(opts)
      @max_length = opts["max_length"]
      @value = opts["value"]
      @options_hash = opts["options_hash"]
    end

    def validate(input)
      return false if input.nil?
      return false if @max_length && input.length > @max_length
      return false if @options_hash.is_a?(Array) && !@options_hash.include?(input)
      return false if @options_hash.is_a?(Hash) && !@options_hash.values.include?(input)
      true
    end

    def ==(other)
      self.max_length == other.max_length &&
        self.value == other.value &&
        self.options_hash == other.options_hash
    end

    def eql?(other)
      self == other
    end

    def hash
      [@max_length, @value, @options_hash].hash
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
      return {}
    end
  end

  def self.base_url
    Rails.application.config.congress_forms_url
  end
end
