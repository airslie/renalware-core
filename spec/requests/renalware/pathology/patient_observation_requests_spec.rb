require "rails_helper"

RSpec.describe "Patient's Observation Requests", type: :request do
  let(:patient) { create(:pathology_patient) }

  describe "GET index" do
    before { create(:pathology_observation_request, patient: patient) }

    it "responds with a list" do
      get patient_pathology_observation_requests_path(patient_id: patient.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    let(:observation_request) { create(:pathology_observation_request, patient: patient) }

    before { create(:pathology_observation, request: observation_request) }

    it "responds with details" do
      get patient_pathology_observation_request_path(
        patient_id: patient.id, id: observation_request.id)

      expect(response).to have_http_status(:success)
    end
  end
end
