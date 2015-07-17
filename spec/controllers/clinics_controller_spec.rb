require 'rails_helper'

describe ClinicsController, type: :controller do

  let(:clinic) { create(:clinic) }
  let(:patient) { create(:patient, clinics: [clinic]) }

  describe 'GET index' do
    before do
      get :index, { patient_id: patient.to_param }
    end
    it 'responds successfully' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns clinics for the patient' do
      expect(assigns(:clinics).first).to eq(clinic)
    end
  end

  describe 'GET new' do
    before do
      get :new, { patient_id: patient.to_param }
    end
    it 'responds successfully' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns a new Clinic' do
      expect(assigns(:clinic)).to be_a(Clinic)
    end
  end

  describe 'POST create' do
    before do
      post :create, patient_id: patient.to_param, clinic: {
        patient_id: patient.to_param, date: Time.now,
        height: 1725, weight: 89.2, bp: '110/78',
        urine_blood: 'neg', urine_protein: 'neg',
        notes: 'Nothing unusual' }
    end
    it 'redirects to the clinics index' do
      expect(response).to redirect_to(patient_clinics_path(patient))
    end
  end

  describe 'GET edit' do
    before do
      get :edit, { patient_id: patient.to_param, id: clinic.to_param }
    end
    it 'responds successfully' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the Clinic by id param' do
      expect(assigns(:clinic)).to eq(clinic)
    end
  end

  describe 'PUT update' do
    before do
      put :update, patient_id: patient.to_param, id: clinic.to_param,
        clinic: {
          patient_id: patient.to_param, date: Time.now,
          height: 1725, weight: 89.2, bp: '110/70',
          urine_blood: 'neg', urine_protein: 'neg',
          notes: 'Nothing unusual' }
    end
    it 'redirects to the clinics index' do
      expect(response).to redirect_to(patient_clinics_path(patient))
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a clinic' do
      expect{
        delete :destroy, patient_id: patient.to_param, id: clinic.to_param
      }.to change(patient.clinics, :count).by(-1)
    end
  end
end
