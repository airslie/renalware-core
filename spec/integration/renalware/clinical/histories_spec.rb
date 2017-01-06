require "rails_helper"

RSpec.describe "History management", type: :request do
  let(:patient) { Renalware::Clinical.cast_patient(create(:patient)) }
  let(:user) { create(:user) }

  describe "PUT update" do
    it "responds successfully" do
      headers = { "HTTP_REFERER" => "/" }
      url = patient_clinical_history_path(patient_id: patient.to_param)
      params = { history: { smoking: "former", alcohol: "rarely" } }

      put(url, params, headers)

      follow_redirect!
      expect(response).to have_http_status(:success)

      history = patient.reload.document.history
      expect(history.alcohol).to eq("rarely")
      expect(history.smoking).to eq("former")
    end
  end
end
