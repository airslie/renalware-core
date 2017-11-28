require "rails_helper"

RSpec.describe "Low Clearance MDM", type: :request do
  describe "GET show" do
    it "responds successfully" do
      patient = create(:patient, family_name: "Rabbit", local_patient_id: "KCH12345")

      get patient_renal_low_clearance_mdm_path(patient)

      expect(response).to have_http_status(:success)
    end
  end
end
