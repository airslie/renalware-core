require 'rails_helper'

module Renalware
  describe ModalitiesController, :type => :controller do

    before do
      @patient = create(:patient)
      @modality = create(:modality)
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
          expect(assigns(:modality)).to be_a(Modality)
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
          @patient.modalities << create(:modality)
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
        it 'succeeds' do
          modality_code = create(:modality_code)
          post :create, patient_id: @patient.to_param, modality: { modality_code_id: modality_code.to_param, start_date: '2015-04-21', notes: 'Notes' }
          expect(response).to redirect_to(patient_modalities_path(@patient))
        end

        context 'and death modality' do
          before do
            death_modality_code = create(:modality_code, name: 'Death')
            post :create, patient_id: @patient.to_param, modality: { modality_code_id: death_modality_code.to_param, start_date: '2015-04-22', notes: 'Death notes' }
          end

          it 'succeeds with redirect to update cause of death' do
            expect(response).to redirect_to(death_update_patient_path(@patient))
          end
        end
      end
    end

  end
end