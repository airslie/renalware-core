require "rails_helper"

RSpec.describe "Patient's Body Compositions", type: :request do
  let(:patient) { create(:clinical_patient) }

  describe "GET index" do
    before do
      create(:body_composition, patient: Renalware::Clinical.cast_patient(patient))
    end

    it "responds with a list" do
      get patient_clinical_profile_path(patient_id: patient.to_param)

      expect(response).to have_http_status(:success)
    end
  end
end
