require 'rails_helper'

feature 'Patient problems' do
  include Select2SpecHelper

  background do
    @patient = create(:patient)
    login_as create(:user, :approved)
    visit problems_patient_path(@patient)

    click_on 'Add a new problem'
    select2 'Anemia of diabetes', '#snomed_term'
    fill_in 'Description', with: 'a description'
    click_on 'Save Problems'

    expect(page).to have_css("dl.accordion dd.accordion-navigation a", text: 'a description')
    expect(@patient.reload.patient_problems.last.snomed_id).to eq('824516018')
  end
end
