require 'rails_helper'

feature 'Updating user profile' do
  background do
    @clinician = login_as_clinician
    visit edit_user_registration_path(@clinician)
  end

  scenario 'updating professional position' do
    fill_in 'Professional position', with: 'Renal Nurse'
    fill_in 'Current password', with: @clinician.password
    click_on 'Update'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Your account has been updated successfully')
    expect(@clinician.reload.professional_position).to eq('Renal Nurse')
  end
end
