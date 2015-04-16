require 'rails_helper'

describe PatientModalitiesController, :type => :controller do

  before do
    @patient = FactoryGirl.create(:patient)
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
        modality = assigns(:modality)
        expect(modality).to be_a(PatientModality)
      end
    end
  end

  describe 'index' do
  end

  describe 'create' do
  end

end
