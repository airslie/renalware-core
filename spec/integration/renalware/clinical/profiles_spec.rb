require "rails_helper"

RSpec.describe "Viewing clinical profile", type: :request do
  let(:patient) { Renalware::Clinical.cast_patient(create(:patient)) }

  describe "GET show" do
    it "responds successfully" do
      get patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    it "responds successfully" do
      get edit_patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT update" do
    it "responds successfully" do
      url = patient_clinical_profile_path(patient_id: patient.to_param)
      headers = { "HTTP_REFERER" => "/" }
      params = {
        clinical_profile: {
          history: { smoking: "former", alcohol: "rarely" },
          diabetes: { diagnosis: "true", diagnosed_on: "12-12-2017" }
        }
      }

      put(url, params: params, headers: headers)

      follow_redirect!
      expect(response).to have_http_status(:success)

      history = patient.reload.document.history
      expect(history.alcohol).to eq("rarely")
      expect(history.smoking).to eq("former")
    end
  end
end
