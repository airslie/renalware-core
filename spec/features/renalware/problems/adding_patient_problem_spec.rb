require "rails_helper"

module Renalware
  feature "Patient problems" do
    background do
      @patient = create(:patient)
      login_as_clinician
      visit patient_problems_path(@patient)
    end

    scenario "A clinician saves a new problem" do
      click_on "Add problem"
      fill_in "Description", with: "a description"
      click_on "Save"

      expect(page).to have_css(".problems_problem", text: "a description")
      expect(@patient.problems.last.description).to eq("a description")
    end

    scenario "A clinician saves a new problem with no descriptions" do
      click_on "Add problem"
      expect { click_on "Save" }.to change(Problems::Problem, :count).by(0)
    end
  end
end
