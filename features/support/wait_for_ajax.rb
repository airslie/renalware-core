module AjaxHelpers

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    if page.driver.is_a? Capybara::RackTest::Driver
      true
    else
      page.evaluate_script("jQuery.active").zero?
    end
  end

end

World(AjaxHelpers)