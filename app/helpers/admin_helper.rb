module AdminHelper
  def nav_link_to(text, url, opts = {})
    opts[:class] = "active" if url == url_for
    link_to(text, url, opts)
  end
end
