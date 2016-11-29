module AhoyHelper
  def ahoy_track_tag(action_type, action_page_id)
    content_tag(:div, style: "height: 0; overflow: hidden") {
      params = { action_type: action_type, action_page_id: action_page_id, format: :gif }
      image_tag(ahoy_visit_url(params), style: "border: 0", alt: "")
    }
  end
end
