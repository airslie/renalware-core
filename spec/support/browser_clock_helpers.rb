module BrowserClockHelpers
  def freeze_time_in_server_and_browser
    freeze_time
    browser do |playwright_page|
      playwright_page.clock.install(time: Time.current)
      playwright_page.clock.pause_at(Time.current)
    end
  end

  def browser(&) = page.driver.with_playwright_page(&)

  def advance(duration)
    travel(duration)
    run_browser_clock_for(duration)
  end

  def run_browser_clock_for(duration)
    browser { |playwright_page| playwright_page.clock.run_for(duration.in_milliseconds.to_i) }
  end

  def awaiting_keep_alive(&)
    browser { |playwright_page| playwright_page.expect_response(/keep_session_alive/, &) }
  end

  def expect_user_still_on_the_page
    expect(page).to have_current_path(root_path)
    expect(page.evaluate_script("window.notReloaded")).to be(true)
  end
end
