module AjaxHelpers
  def wait_for_ajax(timeout = Capybara.default_max_wait_time)
    Timeout.timeout(timeout) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.driver.is_a?(Capybara::RackTest::Driver) || page.evaluate_script("jQuery.active").zero?
  end

  def wait_for_turbo_frame(selector = "turbo-frame", timeout = nil)
    if has_selector?("#{selector}[busy]", visible: true, wait: 0.25.seconds)
      has_no_selector?("#{selector}[busy]", wait: timeout.presence || 5.seconds)
    end
  end
end
