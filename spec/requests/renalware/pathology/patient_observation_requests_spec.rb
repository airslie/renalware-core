require "rails_helper"

RSpec.describe "Patient's Observation Requests", type: :request do
  let(:patient) { create(:pathology_patient) }

  describe "GET index" do
    before do
      create(:pathology_observation_request, patient: patient)
    end

    it "responds with a list" do
      get patient_pathology_observation_requests_path(patient_id: patient.id)

      expect(response).to have_http_status(:success)
    end
  end
end
