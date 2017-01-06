module CsrfProtectionHelper
  def csrf_meta_tags
    if Rails.application.config.esi_enabled
      tag("esi:include", src: meta_tags_path(format: :html))
    else
      super
    end
  end

  def token_tag(token=nil)
    if Rails.application.config.esi_enabled
      tag("esi:include", src: authenticity_token_path(format: :html))
    else
      super(token)
    end
  end
end
