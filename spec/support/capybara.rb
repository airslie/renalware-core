if defined?(Capybara)
  # When this option is enabled, you can insert page.driver.debug into your tests
  # to pause the test and launch a browser which gives you the WebKit inspector
  # to view your test run with.
  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      inspector: "open",
      debug: false
    )
  end

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      window_size: [1366, 1768],
      js_errors: true
    )
  end

  # Capybara.javascript_driver = :poltergeist_debug
  Capybara.javascript_driver = :poltergeist
end
