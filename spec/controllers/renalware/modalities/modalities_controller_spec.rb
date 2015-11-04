require "rails_helper"

module Renalware
  describe Modalities::ModalitiesController, type: :controller do

    before do
      @patient = create(:patient)
      @modality = create(:modality)
    end

    describe "new" do
      context "without a patient" do
        it "errors" do
          expect { get :new }.to raise_error(ActionController::UrlGenerationError)
        end
      end

      context "with a patient" do
        before do
          get :new, patient_id: @patient.to_param
        end

        it "succeeds" do
          expect(response).to be_success
        end
        it "assigns a new PatientModality" do
          expect(assigns(:modality)).to be_a(Modalities::Modality)
        end
      end
    end

    describe "index" do
      context "without a patient" do
        it "errors" do
          expect { get :index }.to raise_error(ActionController::UrlGenerationError)
        end
      end

      context "with a patient" do
        before do
          @patient.modalities << create(:modality)
          get :index, patient_id: @patient.to_param
        end

        it "succeeds" do
          expect(response).to be_success
        end
        it "assigns modalities" do
          expect(assigns(:modalities)).not_to be_empty
        end
      end
    end

    describe "create" do
      context "with a valid modality" do
        it "succeeds" do
          modality_description = create(:modality_description)
          post :create,
            patient_id: @patient.to_param,
            modality: {
              modality_description_id: modality_description.to_param,
              started_on: "2015-04-21",
              notes: "Notes"
            }

          expect(response).to redirect_to(patient_modalities_path(@patient))
        end
      end

      context "with an invalid modality" do
        it "fails" do
          modality_description = create(:modality_description)
          post :create,
            patient_id: @patient.to_param,
            modality: { notes: "Notes" }

          expect(response).to be_success
        end

        context "and death modality" do
          before do
            death_modality_description = create(:modality_description, name: "Death")
            post :create,
            patient_id: @patient.to_param,
            modality: {
              modality_description_id: death_modality_description.to_param,
              started_on: "2015-04-22",
              notes: "Death notes"
            }
          end

          it "succeeds with redirect to update cause of death" do
            expect(response).to redirect_to(edit_patient_death_path(@patient))
          end
        end
      end
    end

  end
end
