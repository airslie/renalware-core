require "rails_helper"

RSpec.describe "Transplants MDM Patients", type: :feature do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  describe "GET index" do
    it "responds successfully" do

      patient = create(:patient,
                       family_name: "Rabbit",
                       local_patient_id: "KCH12345")

      set_modality(patient: patient,
                   modality_description: create(:transplant_donor_modality_description),
                   by: user)

      login_as_clinician
      visit transplants_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end
  end
end
