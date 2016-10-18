json.array! @actionPages do |actionPage|
  json.url action_page_url actionPage
  json.title actionPage.title
  json.summary markdown actionPage.summary
  if actionPage.featured_image_file_name
    json.featured_image do
      json.alt image_alt actionPage.featured_image_file_name
      json.url image_url actionPage.featured_image
    end
  end
end
