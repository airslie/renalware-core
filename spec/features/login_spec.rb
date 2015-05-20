require 'rails_helper'

feature 'Logging in' do
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
end
