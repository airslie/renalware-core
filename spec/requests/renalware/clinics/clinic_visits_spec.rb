require 'rails_helper'

RSpec.describe "Clinic Visits Management", type: :request do

  let(:clinic) { create(:clinic) }
  let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }
  let!(:clinic_visit) { create(:clinic_visit, patient: patient) }

  describe "GET index" do
    before do
      get patient_clinic_visits_path(patient_id: patient.to_param)
    end

    it "responds successfully" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    before do
      get new_patient_clinic_visit_path(patient_id: patient.to_param)
    end
    it "responds successfully" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    before do
      post patient_clinic_visits_path(patient_id: patient.to_param), 
        { 
          clinic_visit: {
            date: Time.now,
            clinic_id: clinic,
            height: 1725, weight: 89.2, bp: "110/78",
            urine_blood: "neg", urine_protein: "neg",
            notes: "Nothing unusual" 
          } 
        }
    end
    it "responds successfully" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    before do
      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end
    it "responds successfully" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT update" do
    before do
      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
        {
          clinic_visit: {
            date: Time.now,
            height: 1725, weight: 89.2, bp: "110/70",
            urine_blood: "neg", urine_protein: "neg",
            notes: "Nothing unusual" }
        }
    end
    it "redirects to the clinic_visits index" do
      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end
  end

  describe "DELETE destroy" do
    subject do 
      delete patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "deletes a clinic_visit" do
      expect{ subject }.to change(patient.clinic_visits, :count).by(-1)
    end
  end
end