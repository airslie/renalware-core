require 'capybara/poltergeist'

# When this option is enabled, you can insert page.driver.debug into your tests
# to pause the test and launch a browser which gives you the WebKit inspector
# to view your test run with.
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    inspector: "open",
    debug: true
  )
end

Capybara.javascript_driver = :poltergeist
# Capybara.javascript_driver = :poltergeist_debug
