require "rails_helper"

RSpec.describe "HD MDM Patients", type: :feature do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  describe "GET index" do
    it "responds successfully" do

      patient = create(:hd_patient,
                       family_name: "Rabbit",
                       local_patient_id: "KCH12345")

      set_modality(patient: patient,
                   modality_description: create(:hd_modality_description))

      login_as_clinician
      visit hd_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end
  end
end
