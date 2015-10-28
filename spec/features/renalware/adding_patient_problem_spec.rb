require 'rails_helper'

module Renalware
  feature 'Patient problems' do
    include Select2SpecHelper

    background do
      @patient = create(:patient)
      login_as_clinician
      visit patient_problems_path(@patient)
    end

    scenario 'A clinician saves a new problem', js: true do
      click_on 'Add a new problem'
      fill_in 'Description', with: 'a description'
      click_on 'Save Problems'

      expect(page).to have_css("dl.accordion dd.accordion-navigation a", text: 'a description')
      expect(@patient.problems.last.description).to eq('a description')
    end

    scenario 'A clinician saves a new problem with no descriptions', js: true do
      click_on 'Add a new problem'
      expect { click_on 'Save Problems' }.to change(Problem, :count).by(0)
    end
  end
end
