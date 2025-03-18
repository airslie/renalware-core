# Capybara.register_driver(:rw_headless_chrome) do |app|
#   options = Selenium::WebDriver::Chrome::Options.new
#   options.add_argument("window-size=1366,1768")
#   options.add_argument("headless")
#   options.add_argument("disable-gpu")
#   options.add_argument("disable-extensions")
#   options.add_preference(:download, prompt_for_download: false)
#   options.add_preference(:download, default_directory: Rails.root.join("tmp"))
#   options.add_argument("no-sandbox")
#   options.add_argument("enable-features=NetworkService,NetworkServiceInProcess")

#   Capybara::Selenium::Driver.new(
#     app,
#     browser: :chrome,
#     options: options
#   )
# end

# unless ENV.key?("SEMAPHORECI")
#   Capybara::Screenshot.register_driver(:rw_headless_chrome) do |driver, path|
#     driver.browser.save_screenshot(path)
#   end
# end

# Capybara.javascript_driver = :rw_headless_chrome

# Capybara.register_driver :my_playwright do |app|
#   Capybara::Playwright::Driver.new(app,
#     browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
#     headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"])
#   )
# end

# Capybara.javascript_driver = :my_playwright
# require 'capybara-playwright-driver'
# Capybara.register_driver(:playwright) do |app|
#   Capybara::Playwright::Driver.new(app, browser_type: :firefox, headless: false)
# end
# Capybara.default_max_wait_time = 15
# Capybara.default_driver = :playwright
# Capybara.javascript_driver = :playwright
# Capybara.save_path = 'tmp/capybara'

# Capybara::Screenshot.register_driver(:playwright) do |driver, path|
#   driver.save_screenshot(path)
# end
