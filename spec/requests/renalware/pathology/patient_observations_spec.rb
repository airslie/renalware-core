require "rails_helper"

RSpec.describe "Patient's Observations", type: :request do
  let(:patient) { create(:pathology_patient) }

  describe "GET index" do
    let(:observation_request) { create(:pathology_observation_request, patient: patient) }
    let(:observation_description) { create(:pathology_observation_description) }

    before { create_pair(:pathology_observation, request: observation_request, description: observation_description) }

    it "responds with details" do
      get patient_pathology_observations_path(
        patient_id: patient.id, description_id: observation_request.id)

      expect(response).to have_http_status(:success)
    end
  end
end
