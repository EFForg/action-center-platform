class AhoyController < ApplicationController
  before_action :set_ahoy_cookies
  before_action :track_ahoy_visit
  before_action :set_ahoy_request_store

  def visit
    action_type = params.require(:action_type)
    action_page_id = params.require(:action_page_id)

    ahoy.track "View",
      { type: "action", actionType: action_type, actionPageId: action_page_id },
      action_page_id: action_page_id

    send_data image_asset, content_type: "image/gif"
  end

  private

  def image_asset
    # app/assets/images/empty.gif
    "GIF89a\u0001\u0000\u0001\u0000\x80\u0000\u0000\xFF\xFF\xFF\u0000\u0000\u0000!\xF9\u0004\u0001\u0000\u0000\u0000\u0000,\u0000\u0000\u0000\u0000\u0001\u0000\u0001\u0000\u0000\u0002\u0002D\u0001\u0000;"
  end
end
