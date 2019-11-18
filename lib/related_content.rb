class RelatedContent
  def initialize(url)
    @url = url
  end

  def load
    return if url.blank?
    begin
      open_page
      @loaded_successfully = true
    rescue OpenURI::HTTPError
      return
    end
  end

  def found?
    @loaded_successfully
  end

  def title
    @title ||= page.title.gsub(/ \|.*/, "")
  end

  def image
    return @image if @image
    og_url = page.css("meta[property='og:image']")
    @image = if og_url.blank?
               ""
             else
               og_url.first.attribute("content").value
             end
  end

  private

  attr_reader :url, :page, :loaded_successfully

  def open_page
    @page ||= Nokogiri::HTML(open(url))
  end
end
