
When /^I byebug$/ do
  byebug
end

When /^I save the page$/ do
  # Saves HTML to tmp/capybara.
  save_page
end

When /^I (save|take) a screenshot$/ do |_|
  # Saves png to tmp/capybara.
  path = Rails.root.join("tmp/capybara/#{SecureRandom.hex(8)}#{page.current_path.gsub('/', '-')}.png")
  FileUtils.mkdir_p(File.dirname(path))
  page.save_screenshot(path)
  puts("screenshot saved to #{path}")
end

When(/^I wait (.*?) seconds$/) do |seconds|
  sleep(seconds.to_i)
end
