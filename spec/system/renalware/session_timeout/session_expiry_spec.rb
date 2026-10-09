# Time is advanced rather than waited for: see BrowserClockHelpers.
describe "Session timeout", :js do
  include BrowserClockHelpers

  around do |example|
    original_session_timeout = Devise.timeout_in
    original_activity = Renalware.config.session_register_user_user_activity_after
    original_warning = Renalware.config.session_timeout_warning

    Devise.timeout_in = 20.minutes
    Renalware.config.session_register_user_user_activity_after = 1.minute
    Renalware.config.session_timeout_warning = 0.seconds

    example.run
  ensure
    Devise.timeout_in = original_session_timeout
    Renalware.config.session_register_user_user_activity_after = original_activity
    Renalware.config.session_timeout_warning = original_warning
  end

  let(:activity_registered_after) { Renalware.config.session_register_user_user_activity_after }
  let(:half_the_original_session) { Devise.timeout_in / 2 }
  let(:past_original_expiry) { Devise.timeout_in - half_the_original_session + 1.minute }

  before do
    freeze_time_in_server_and_browser
    login_as_clinical
    visit root_path
    page.execute_script("window.notReloaded = true")
  end

  def expect_activity_to_restart_the_session_window
    advance(half_the_original_session)
    yield
    awaiting_keep_alive { advance(activity_registered_after) }

    advance(past_original_expiry)
    expect_user_still_on_the_page
  end

  it "A user is redirected by JS to the login page when their session expires" do
    expect(page).to have_current_path(root_path)

    advance(Devise.timeout_in + 1.second)

    expect(page).to have_current_path(new_user_session_path)
  end

  it "restarts the session window when the user clicks the page" do
    expect_activity_to_restart_the_session_window { find("main").click }
  end

  it "restarts the session window when the user presses a key" do
    expect_activity_to_restart_the_session_window do
      page.execute_script(
        "document.dispatchEvent(new KeyboardEvent('keydown', { key: 'x', bubbles: true }))"
      )
    end
  end
end
