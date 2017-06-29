require "rails_helper"
require "renalware/clinical"

RSpec.describe "Allergy management", type: :request do
  let(:patient) { Renalware::Clinical.cast_patient(create(:patient)) }
  let(:user) { create(:user) }

  describe "POST create" do
    it "responds successfully" do
      headers = { "HTTP_REFERER" => "/" }
      url = patient_clinical_allergies_path(patient_id: patient.to_param)
      params = { clinical_allergy: { description: "Nuts" } }

      expect{
        post(url, params: params, headers: headers)
      }.to change(patient.allergies, :count).by(1)
      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE destroy" do
    it "deletes the allergy" do
      headers = { "HTTP_REFERER" => "/" }
      allergy = create(:allergy, patient: patient, by: user)
      url = patient_clinical_allergy_path(patient_id: patient.to_param, id: allergy.to_param)

      expect{ delete(url, headers: headers) }.to change(patient.allergies, :count).by(-1)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(patient.allergies.with_deleted.count).to eq(1)
    end
  end
end
