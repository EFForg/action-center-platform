class CsrfProtectionController < ActionController::Base
  include ActionView::Helpers::TagHelper

  def meta_tags
  end

  def authenticity_token
  end
end
