require "rails_helper"

module Renalware
  RSpec.describe "Clinical summary", type: :feature do

    describe "GET show" do
      it "renders correctly" do
        user = create(:user)
        patient = create(:patient)
        create(:problem, patient: patient, created_by: user, updated_by: user)
        create(:simple_event, patient: patient, created_by: user, updated_by: user)
        create(:prescription, patient: patient, created_by: user, updated_by: user)

        letter_patient = Letters.cast_patient(patient)
        letter = build(:approved_letter, patient: letter_patient)
        letter.build_main_recipient(person_role: :primary_care_physician)
        letter.save!

        login_as_clinician
        visit patient_clinical_summary_path(patient)

        expect(page).to have_content "Problems (1)"
        expect(page).to have_content "Events (1)"
        expect(page).to have_content "Letters (1)"
        expect(page).to have_content "Prescriptions (1)"
      end
    end
  end
end
