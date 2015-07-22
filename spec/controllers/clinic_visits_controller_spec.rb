require 'rails_helper'

describe ClinicVisitsController, type: :controller do

  let(:clinic_visit) { create(:clinic_visit) }
  let(:patient) { create(:patient, clinic_visits: [clinic_visit]) }

  describe 'GET index' do
    before do
      get :index, { patient_id: patient.to_param }
    end
    it 'responds successfully' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns clinic_visits for the patient' do
      expect(assigns(:clinic_visits).first).to eq(clinic_visit)
    end
  end

  describe 'GET new' do
    before do
      get :new, { patient_id: patient.to_param }
    end
    it 'responds successfully' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns a new ClinicVisit' do
      expect(assigns(:clinic_visit)).to be_a(ClinicVisit)
    end
  end

  describe 'POST create' do
    before do
      post :create, patient_id: patient.to_param, clinic_visit: {
        patient_id: patient.to_param, date: Time.now,
        height: 1725, weight: 89.2, bp: '110/78',
        urine_blood: 'neg', urine_protein: 'neg',
        notes: 'Nothing unusual' }
    end
    it 'redirects to the clinic_visits index' do
      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end
  end

  describe 'GET edit' do
    before do
      get :edit, { patient_id: patient.to_param, id: clinic_visit.to_param }
    end
    it 'responds successfully' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the ClinicVisit by id param' do
      expect(assigns(:clinic_visit)).to eq(clinic_visit)
    end
  end

  describe 'PUT update' do
    before do
      put :update, patient_id: patient.to_param, id: clinic_visit.to_param,
        clinic_visit: {
          patient_id: patient.to_param, date: Time.now,
          height: 1725, weight: 89.2, bp: '110/70',
          urine_blood: 'neg', urine_protein: 'neg',
          notes: 'Nothing unusual' }
    end
    it 'redirects to the clinic_visits index' do
      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a clinic_visit' do
      expect{
        delete :destroy, patient_id: patient.to_param, id: clinic_visit.to_param
      }.to change(patient.clinic_visits, :count).by(-1)
    end
  end
end
