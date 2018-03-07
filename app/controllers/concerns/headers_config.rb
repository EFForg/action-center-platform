module HeadersConfig
  extend ActiveSupport::Concern

  included do
    after_action :config_headers
  end

  def config_headers
    controller_map = config_headers_map[controller_name] || {}
    (controller_map[action_name] || {}).each do |k, v|
      response.headers[k] ||= v
    end
  end

  private

  def config_headers_map
    if Rails.env.production?
      @_config_headers ||=
        YAML.load_file(Rails.root.join("config/headers.yml"))
    else
      YAML.load_file(Rails.root.join("config/headers.yml"))
    end
  end
end
