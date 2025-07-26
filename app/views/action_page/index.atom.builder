atom_feed do |feed|
  feed.title(t(:site_title))
  feed.subtitle(t(:summary))
  feed.updated(@actionPages[0].created_at) unless @actionPages.empty?

  @actionPages.each do |actionPage|
    feed.entry(actionPage) do |entry|
      entry.link(
        rel: "enclosure",
        type: (actionPage.featured_image_content_type || "image/png"),
        href: actionPage.featured_image.url
      )

      entry.title(actionPage.title)
      entry.summary(markdown(actionPage.summary), type: "html")
      entry.content(markdown(actionPage.description), type: "html")

      entry.author do |author|
        author.name(t(:organization_name))
      end
    end
  end
end
