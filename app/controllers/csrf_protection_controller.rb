class CsrfProtectionController < ActionController::Base
  include ActionView::Helpers::TagHelper

  def meta_tags
    param = tag("meta", name: "csrf-param", content: "authenticity_token")
    token = tag("meta", name: "csrf-token", content: form_authenticity_token)
    render inline: param+token
  end

  def authenticity_token
    render inline: tag("input", type: "hidden", name: "authenticity_token", id: "authenticity_token",
                       value: form_authenticity_token)
  end
end
