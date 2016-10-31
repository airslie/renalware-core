require "rails_helper"

RSpec.describe "Managing an HD DNA Session", type: :request do

  describe "GET show" do
    it "renders successfully" do
      dna_session = create(:hd_dna_session)
      get patient_hd_session_path(patient_id: dna_session.patient.id, id: dna_session.id)

      expect(response).to have_http_status(:success)
    end
  end
end
