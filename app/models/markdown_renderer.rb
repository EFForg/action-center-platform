class MarkdownRenderer < Redcarpet::Render::HTML
  # Assume 'code' here is actually just more markdown
  # that wants to be rendered and wrapped in a .letter class
  def block_code(code, language)
    renderOptions = { hard_wrap: true, filter_html: false }
    markdownOptions = { autolink: true, no_intra_emphasis: true }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(renderOptions), markdownOptions)

    if language == "letter"
      ApplicationController.new.render_to_string partial: "action_page/letter", locals: { description: code }, layout: false
    else
      "<div class='#{language}'>#{markdown.render(code)}</div>"
    end
  end
end
