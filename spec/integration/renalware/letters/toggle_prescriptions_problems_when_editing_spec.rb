# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe(
    "Toggle current problems & prescriptions when editing letter",
    js: true,
    type: :system
  ) do
    include LettersSpecHelper

    context "when a user is creating or editing a clinical letter" do
      it "they can toggle open the patient's prescriptions and problems to get context" do
        user = login_as_clinical
        patient = create(:letter_patient, by: user)
        problem = create(:problem, patient: patient, description: "Problem 1", by: user)
        prescription = create(:prescription, patient: patient, by: user)

        visit new_patient_letters_letter_path(patient)

        within ".letter-form-problems-and-prescriptions" do
          expect(page).to have_content("Problems and Prescriptions")
          expect(page).not_to have_content(problem.description)
          expect(page).not_to have_content(prescription.drug.name)

          click_on t("btn.toggle")

          expect(page).to have_content(problem.description)
          expect(page).to have_content(prescription.drug.name)
        end
      end
    end
  end
end
