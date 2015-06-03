require 'rails_helper'

feature 'Authentication' do
  background do
    @user = create(:user, :approved, :clinician)
    @unapproved_user = create(:user)
  end

  scenario 'A user attempts to authenticate with invalid credentials' do
    visit root_path

    expect(current_path).to eq(new_user_session_path)

    fill_in 'Username', with: @user.username
    fill_in 'Password', with: 'wuhfweilubfwlf'
    click_on 'Log in'

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_css('.flash-alert', text: /Invalid username or password/)
  end

  scenario 'An unapproved user authenticates with valid credentials' do
    visit root_path

    expect(current_path).to eq(new_user_session_path)

    fill_in 'Username', with: @unapproved_user.username
    fill_in 'Password', with: @unapproved_user.password
    click_on 'Log in'

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_css('.flash-alert', text: /Your account needs approval before you can access the system/)
  end

  scenario 'An approved user authenticates with valid credentials' do
    visit root_path

    expect(current_path).to eq(new_user_session_path)

    fill_in 'Username', with: @user.username
    fill_in 'Password', with: @user.password
    click_on 'Log in'

    expect(current_path).to eq(root_path)
  end

  scenario 'An authenticated user signs out' do
    login_as_clinician
    visit root_path

    click_on 'Log out'

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'An inactive user attempts to authenticate' do
    inactive = create(:user, :approved, :clinician,
                      last_activity_at: 60.days.ago)

    visit new_user_session_path

    fill_in 'Username', with: inactive.username
    fill_in 'Password', with: inactive.password
    click_on 'Log in'

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_css('.flash-alert', text: /Your account has expired due to inactivity\. Please contact the site administrator/)
  end

  scenario 'A fairly inactive user attempts to authenticate' do
    inactive = create(:user, :approved, :clinician,
                      last_activity_at: 59.days.ago)

    visit new_user_session_path

    fill_in 'Username', with: inactive.username
    fill_in 'Password', with: inactive.password
    click_on 'Log in'

    expect(current_path).to eq(root_path)
  end
end
