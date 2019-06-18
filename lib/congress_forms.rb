require "rest_client"

module CongressForms
  class Form
    attr_accessor :fields

    def self.find(bioguide_ids)
      raw_forms = CongressForms.post("/retrieve-form-elements/", {
        bio_ids: bioguide_ids
      })
      raw_forms.values.map { |raw| Form.new(raw["required_actions"]) }
    end

    def self.group_common_fields(fields_list)
    end

    def initialize(fields)
      @fields = fields.map{ |f| Field.new(f) }
    end

    def validate(data)
      @fields.each do |f|
        return false unless f.validate(data[f.value])
      end
      true
    end

    def fill(message)
      params = {}
      @fields.each do |f|
        params[f.value] = f.get_input(data)
      end
      CongressMessage.post("/fill-out-form/", params)
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
  end

  def self.base_url
    Rails.application.config.congress_forms_url
  end

  def self.url(path = "/", params = {}, bioguide_id = nil)
    url = base_url + path
    url += bioguide_id unless bioguide_id.nil?
    url += "?" + {
      debug_key: Rails.application.secrets.congress_forms_debug_key,
    }.merge(params).to_query
  end

  def self.post(path = "/", params = {})
    begin
      JSON.parse RestClient.post(base_url + path, params)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e
      return {}
    end
  end

  # @TODO fix stats calls, refactor
  def self.get(path = "/", params = {}, bioguide_id = nil)
    begin
      JSON.parse RestClient.get(url(path, params, bioguide_id))
    rescue RestClient::ExceptionWithResponse => e
      Raven.capture_exception(e)
      Rails.logger.error e
      return {}
    end
  end
end
