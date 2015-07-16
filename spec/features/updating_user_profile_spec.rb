require 'rails_helper'

feature 'Updating user profile' do
  background do
    @clinician = login_as_clinician
    visit edit_user_registration_path(@clinician)
  end

  scenario 'updating professional position and signature' do
    fill_in 'Professional position', with: 'Renal Nurse'
    fill_in 'Signature', with: 'Dr. D O Good, Senior Human Mechanic, Trumpton Hospital'
    fill_in 'Current password', with: @clinician.password
    click_on 'Update'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Your account has been updated successfully')
    expect(@clinician.reload.professional_position).to eq('Renal Nurse')
    expect(@clinician.signature).to eq('Dr. D O Good, Senior Human Mechanic, Trumpton Hospital')
  end

  scenario 'updating with no signature or professional position' do
    fill_in 'Signature', with: ''
    fill_in 'Current password', with: @clinician.password
    click_on 'Update'

    expect(page).to have_content("Professional position can't be blank")
    expect(page).to have_content("Signature can't be blank")
  end
end
