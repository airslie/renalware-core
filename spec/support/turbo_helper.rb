module TurboHelper
  def wait_for_turbo_frame(selector, timeout = Capybara.default_max_wait_time)
    page.has_selector?("turbo-frame##{selector}[busy]", wait: 0.25)
    page.has_no_selector?("turbo-frame##{selector}[busy]", wait: timeout)
  end
end
