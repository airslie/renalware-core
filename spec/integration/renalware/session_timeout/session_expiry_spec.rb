require "rails_helper"
require "test_support/ajax_helpers"

feature "Session timeout", type: :feature, js: true do
  include AjaxHelpers

  around do |example|
    original_session_timeout = Devise.timeout_in
    Devise.timeout_in = 0.5.seconds

    example.run

    Devise.timeout_in = original_session_timeout
  end

  scenario "A user is redirected by JS to the login page when their session expires" do
    login_as_clinician

    visit root_path

    # Expect to be on the user's dashboard
    expect(page).to have_current_path(root_path)

    100.times do
      sleep 0.3
      # Because we don't want to wait for the default session timeout polling freq
      # to pass (could be 20 seconds), manually invoke the global sessionTimeoutCheck
      # JavaScript function to force a check (and redirect if the session has expired)
      page.execute_script(%Q(window.sessionTimeoutCheck();))
      break if page.current_path == new_user_session_path
    end

    # After a period of inactivity (Devise.timeout_in), expect to have been redirected
    # to the login page
    expect(page).to have_current_path(new_user_session_path)
  end
end
