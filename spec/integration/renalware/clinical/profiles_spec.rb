require "rails_helper"

RSpec.describe "Viewing clinical profile", type: :request do
  let(:patient) { Renalware::Clinical.cast_patient(create(:patient)) }

  describe "GET show" do
    it "responds successfully" do
      get patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to have_http_status(:success)
    end
  end
end
