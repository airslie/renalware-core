require 'rails_helper'

module Renalware
  feature 'A read only user' do
    background do
      @patient = create(:patient, :with_problems, :with_meds)
      login_as_read_only
    end

    scenario 'viewing patient problems' do
      visit patient_problems_path(@patient)

      expect(page).to have_content(@patient.problems.last.description)
      expect(page).not_to have_link('Add a new problem')
    end

    scenario 'viewing patient medications' do
      visit manage_medications_patient_path(@patient)

      expect(page).to have_content(@patient.medications.last.medicatable.name)
      expect(page).not_to have_link('Add a new medication')
    end
  end
end
