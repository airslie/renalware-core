require 'rails_helper'

describe PatientModalitiesController, :type => :controller do

  before do
    @patient = create(:patient)
  end

  describe 'new' do
    context 'without a patient' do
      it 'errors' do
        expect { get :new }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'with a patient' do
      before do
        get :new, patient_id: @patient.to_param
      end

      it 'succeeds' do
        expect(response).to be_success
      end
      it 'assigns a new PatientModality' do
        expect(assigns(:modality)).to be_a(PatientModality)
      end
    end
  end

  describe 'index' do
    context 'without a patient' do
      it 'errors' do
        expect { get :index }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'with a patient' do
      before do
        @patient.patient_modalities << create(:patient_modality)
        get :index, patient_id: @patient.to_param
      end

      it 'succeeds' do
        expect(response).to be_success
      end
      it 'assigns modalities' do
        expect(assigns(:modalities)).not_to be_empty
      end
    end
  end

  describe 'create' do
    context 'without a patient' do
      it 'errors' do
        expect { post :create }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'with a patient' do
      before do
        post :create, patient_id: @patient.to_param, modality: { notes: 'Notes' }
      end

      it 'succeeds' do
        expect(response).to redirect_to(patient_patient_modalities_path(@patient))
      end
    end
  end

end
