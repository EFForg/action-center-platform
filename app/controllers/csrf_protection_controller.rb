class CsrfProtectionController < ActionController::Base
  include ActionView::Helpers::TagHelper

  def meta_tags
    @token = form_authenticity_token
  end

  def authenticity_token
    @token = form_authenticity_token
  end
end
