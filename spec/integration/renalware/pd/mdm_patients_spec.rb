require "rails_helper"

RSpec.describe "PD MDM Patients", type: :feature do
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
      visit pd_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end
  end
end
