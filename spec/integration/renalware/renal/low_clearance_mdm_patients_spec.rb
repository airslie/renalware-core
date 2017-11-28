require "rails_helper"

RSpec.describe "Low Clearance Patients", type: :feature do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  describe "GET index" do
    it "responds successfully" do
      patient = create(:pd_patient,
                       family_name: "Rabbit",
                       local_patient_id: "KCH12345")

      set_modality(patient: patient,
                   modality_description: create(:pd_modality_description),
                   by: user)

      login_as_clinician
      visit renal_low_clearance_mdm_patients_path

      expect(page).to have_content("Low Clearance MDM Patients")
      within ".filters" do
        expect(page).to have_content("bla")
      end
      expect(page).to have_content("")
      expect(page).to have_content(patient.family_name.upcase)
    end
  end
end
