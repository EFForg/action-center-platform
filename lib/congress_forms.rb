require "rest_client"

module CongressForms
  class Form
    attr_accessor :fields

    def self.find(bioguide_ids)
      # POST /retrieve-form-elements
      result = []
      fields_list.each do |fields|
        result << Form.new(fields)
      end
      # Returns an array of Forms
      return result
    end

    def self.group_common_fields(fields_list)

    end

    def initialize(fields)
      @fields = fields
    end

    def validate(data)
      # [
      #   {
      #     maxlength: int,
      #     value: string,
      #     options_hash: hash
      #   },
      #     ...
      # ]
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

    def initialize(max_length, value, options_hash)
      @max_length = max_length
      @value = value
      @options_hash = options_hash
    end

    def validate(input)
      return false if input.nil?
      return false if @max_length && input.length > @max_length
      # @TODO this can be an array or hash - currently checking hash key.
      return false if @options_hash && !@options_hash.include?(input)
      true
    end
  end

  def self.url(path = "/", params = {}, bioguide_id = nil)
    url = Rails.application.config.congress_forms_url + path
    url += bioguide_id unless bioguide_id.nil?
    url += "?" + {
      debug_key: Rails.application.secrets.congress_forms_debug_key,
    }.merge(params).to_query
  end

  def self.post(path = "/", params = {}, bioguide_id = nil)
    begin
      JSON.parse RestClient.get(url(path, params, bioguide_id))
    rescue RestClient::ExceptionWithResponse => e
      Raven.capture_exception(e)
      Rails.logger.error e
      return {}
    end
  end
end
