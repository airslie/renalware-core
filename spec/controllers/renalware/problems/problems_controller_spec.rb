require "rails_helper"

module Renalware::Problems
  RSpec.describe ProblemsController, type: :controller do
    subject { create(:patient) }

    describe "GET index" do
      it "responds with success" do
        get :index, patient_id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "redirects to the problem index" do
          put :update,
          patient_id: subject.id, patient: {
            problem_attributes: { 0 => { description: "testing" } }
          }

          expect(response).to redirect_to(patient_problems_path(subject))
        end
      end

      context "with invalid attributes" do
        it "redirects to the problem index as invalid problems are rejected" do
          put :update, patient_id: subject.id, patient: {problem_attributes: { description: nil }}

          expect(response).to redirect_to(patient_problems_path(subject))
        end
      end
    end
  end
end
