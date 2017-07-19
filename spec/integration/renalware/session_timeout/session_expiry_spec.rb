require "rails_helper"
require "test_support/ajax_helpers"

feature "Session timeout", type: :feature, js: true do
  include AjaxHelpers

  around(:each) do |example|
    original_session_timeout = Devise.timeout_in
    original_polling_frequency = Renalware.config.session_timeout_polling_frequency

    Devise.timeout_in = 0.5.seconds
    Renalware.configure do |config|
      config.session_timeout_polling_frequency = 1.second
    end

    example.run

    Devise.timeout_in = original_session_timeout
    Renalware.configure do |config|
      config.session_timeout_polling_frequency = original_polling_frequency
    end
  end

  scenario "A user is redirected by JS to the login page when their session expires" do
    login_as_clinician
    visit root_path

    # Expect to be on the user's dashboard
    expect(page.current_path).to eq(root_path)

    100.times do
      sleep 0.2
      # wait_for_ajax
      p page.current_path == new_user_session_path
      break if page.current_path == new_user_session_path
    end

    # After a period of inactivity (Devise.timeout_in), expect to have been redirected
    # to the login page
    expect(page.current_path).to eq(new_user_session_path)
  end
end
