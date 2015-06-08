require 'rails_helper'

feature 'Listing patients' do
  background do
    30.times { create(:patient) }

    login_as_clinician
  end

  scenario 'Viewing the first page of patients' do
    visit '/'
    expect(page).to have_css('nav.pagination', text: '1 2 Next › Last »')
  end

  scenario 'Paging to the second page of patients' do
    visit '/'
    click_link 'Next ›'
    expect(page).to have_css('nav.pagination', text: '« First ‹ Prev 1 2')
  end
end
