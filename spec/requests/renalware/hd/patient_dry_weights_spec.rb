require "rails_helper"

RSpec.describe "Patient's Dry Weights", type: :request do
  let(:patient) { create(:patient) }

  describe "GET index" do
    before do
      create(:hd_dry_weight, patient: patient)
    end

    it "responds with a list" do
      get patient_hd_dry_weights_path(patient_id: patient.id)

      expect(response).to have_http_status(:success)
    end
  end
end
