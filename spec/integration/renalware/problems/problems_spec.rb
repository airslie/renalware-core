# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Problems Requests" do
  let!(:patient) { create(:pathology_patient) }
  let!(:problem) { create(:problem, patient: patient) }
  let!(:archived_problem) { create(:problem, patient: patient, deleted_at: Date.current) }

  describe "GET show" do
    context "when viewing a current problem" do
      it "responds with the problem" do
        get patient_problem_path(patient_id: patient, id: problem.id)

        expect(response).to have_http_status(:success)
      end
    end

    context "when viewing an archived problem" do
      it "responds with the problem" do
        get patient_problem_path(patient_id: patient, id: archived_problem.id)

        expect(response).to have_http_status(:success)
      end
    end
  end
end
