require "rails_helper"

module Renalware
  RSpec.describe DeathsController, type: :controller do

    subject { create(:patient) }

    before do
      @edta_code = FactoryGirl.create(:edta_code)
      @modality_code = FactoryGirl.create(:modality_code, :death)
      @patient_modality = FactoryGirl.create(:modality,
        patient_id: subject.id, modality_code_id: @modality_code.id)
    end

    describe "index" do
      it "responds with success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET edit" do
      it "responds with success" do
        get :edit, patient_id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "updates death details" do
          put :update,
          patient_id: subject.id,
          patient: {
            died_on: Date.parse(Time.now.to_s),
            first_edta_code_id: @edta_code.id
          }
          expect(response).to redirect_to(patient_path(subject))
        end
      end

      context "with invalid attributes" do
        it "fails to update death details" do
          put :update, patient_id: subject.id, patient: { died_on: nil }
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
