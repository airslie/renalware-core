require "rails_helper"

RSpec.describe "Viewing archived results", type: :request do

  describe "GET show" do
    it "responds with a table of results" do
      patient = create(:patient)
      create_observations(patient)

      get patient_pathology_observations_path(patient)

      expect(response).to have_http_status(:success)
    end

    def create_observations(patient)
      patient = Renalware::Pathology.cast_patient(patient)
      request = create(:pathology_observation_request, patient: patient)
      observation_description = create(:pathology_observation_description)
      create(:pathology_observation, request: request, description: observation_description)
    end
  end
end
