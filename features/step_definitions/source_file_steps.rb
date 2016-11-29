
When(/^there is an uploaded file named "([^\"]+)"$/) do |file_name|
  step "there is a persisted SourceFile with:", table(%{
    |file_name|#{file_name}|
    |file_content_type|image/png|
    |file_size|#{file_name}|
    |key|#{file_name}|
    |bucket|cucumber_test|
  })
end
