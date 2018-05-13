# # frozen_string_literal: true

Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu window-size=1366,1768) }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

if RUBY_PLATFORM.match?(/darwin/)
  Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end
Capybara.javascript_driver = :headless_chrome
