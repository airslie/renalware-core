require 'rails_helper'

feature 'Authorising, approving and reactivating users' do
  background do
    @approved = create(:user, :approved)
    @unapproved = create(:user)
    @expired = create(:user, :approved, :expired)
    @clinician_role = create(:role, name: 'clinician')

    login_as_super_admin

    visit admin_users_path
  end

  scenario 'An admin approves a newly registered user' do
    click_on 'Unapproved'

    click_link 'Edit'
    expect(current_path).to eq(edit_admin_user_path(@unapproved))

    check 'Clinician'
    click_on 'Approve'

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content(/renalwareuser-\d+ updated/)
    expect(@unapproved.reload).to be_approved
    expect(@unapproved.roles).to match_array([@clinician_role])
  end

  scenario 'An admin approves a user without assigning a role' do
    click_on 'Unapproved'

    click_link 'Edit'
    expect(current_path).to eq(edit_admin_user_path(@unapproved))

    click_on 'Approve'

    expect(current_path).to eq(admin_user_path(@unapproved))
    expect(@unapproved.reload).not_to be_approved
    expect(page).to have_content(/renalwareuser-\d+ could not be updated/)
    expect(page).to have_content(/approved users must have a role/)
  end

  scenario 'An admin removes all roles from a user' do
    within('tbody tr:first-child td:nth-child(7)') do
      click_link 'Edit'
    end
    expect(current_path).to eq(edit_admin_user_path(@approved))

    uncheck 'Super admin'
    click_on 'Update'

    expect(current_path).to eq(admin_user_path(@approved))
    expect(page).to have_content(/renalwareuser-\d+ could not be updated/)
    expect(page).to have_content(/approved users must have a role/)
  end

  scenario 'An admin authorises an existing user with additional roles' do
    within('tbody tr:first-child td:nth-child(7)') do
      click_link 'Edit'
    end
    expect(current_path).to eq(edit_admin_user_path(@approved))

    check 'Clinician'
    click_on 'Update'

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content(/renalwareuser-\d+ updated/)
    expect(@approved.reload).to be_approved
    expect(@approved.roles).to include(@clinician_role)
  end

  scenario 'An admin reactivates an inactive user' do
    click_link 'Inactive'

    within('tbody tr:first-child td:nth-child(7)') do
      click_link 'Edit'
    end
    expect(current_path).to eq(edit_admin_user_path(@expired))

    check 'Reactivate account'
    click_on 'Update'

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content(/renalwareuser-\d+ updated/)
    expect(@expired.reload.expired_at).to be_nil

    click_link 'Inactive'

    expect(page).not_to have_content(@expired.username)
  end
end
