require "rails_helper"

module Renalware
  RSpec.describe DeathsController, type: :controller do
    routes { Engine.routes }

    subject { create(:patient) }

    before do
      @cause = FactoryGirl.create(:cause)
      @modality_description = FactoryGirl.create(:death_modality_description)
      @patient_modality = FactoryGirl.create(:modality,
        patient_id: subject.id, description: @modality_description)
    end

    describe "index" do
      it "responds with success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET edit" do
      it "responds with success" do
        get :edit, params: { patient_id: subject.to_param }
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "updates death details" do
          put :update,
            params: {
              patient_id: subject.to_param,
              patient: {
                died_on: Date.parse(Time.zone.now.to_s),
                first_cause_id: @cause.id
              }
            }
          expect(response).to redirect_to(patient_clinical_profile_path(subject))
        end
      end

      context "with invalid attributes" do
        it "fails to update death details" do
          put :update, params: { patient_id: subject.to_param, patient: { died_on: nil } }
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
