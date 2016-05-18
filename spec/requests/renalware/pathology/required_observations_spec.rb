require "rails_helper"

describe "Viewing required observations" do
  describe "GET /patients/{id}/pathology/required_observations" do
    let!(:patient) { create(:patient) }
    let!(:clinic) { create(:clinic) }

    it "displays a list of patient & global observations required for the patient" do
      get patient_pathology_required_observations_path(patient_id: patient.id)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end
