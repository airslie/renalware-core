require "rails_helper"

RSpec.describe "patient_rules Requests", type: :request do
  let!(:patient) { create(:pathology_patient) }
  let!(:lab) { create(:pathology_lab) }
  let!(:patient_rule) { create(:pathology_request_algorithm_patient_rule, patient: patient, lab: lab) }
  let!(:clinic) { create(:clinic) }

  describe "GET new" do
    xit "responds with a form" do
      get new_patient_pathology_patient_rule_path(patient_id: patient.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    let(:url) { patient_pathology_patient_rules_path(patient_id: patient.id) }
    let(:patient_rule_attributes) do
      attributes_for(:pathology_request_algorithm_patient_rule).merge(
        patient_id: patient.id,
        lab_id: lab.id
      )
    end

    context "given valid attributes" do
      let(:patient_rule_exists) do
        Renalware::Pathology::RequestAlgorithm::PatientRule.exists?(patient_rule_attributes)
      end

      xit "creates a new record" do
        post url, pathology_request_algorithm_patient_rule: patient_rule_attributes

        expect(response).to have_http_status(:redirect)
        expect(patient_rule_exists).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      xit "responds with form" do
        post url, pathology_request_algorithm_patient_rule: patient_rule_attributes.except(:lab_id)

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    xit "responds with a form" do
      get edit_patient_pathology_patient_rule_path(patient_id: patient.id, id: patient_rule.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    let(:url) { patient_pathology_patient_rule_path(patient_id: patient.id, id: patient_rule.id) }

    context "given valid attributes" do
      it "updates the patient rule" do
        patch url, pathology_request_algorithm_patient_rule: { test_description: "Lorem Ipsum" }

        expect(response).to have_http_status(:redirect)

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        patch url, pathology_request_algorithm_patient_rule: { test_description: nil }

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    let(:patient_rule_exists) do
      Renalware::Pathology::RequestAlgorithm::PatientRule.exists?(id: patient_rule.id)
    end

    xit "deletes the patient rule" do
      delete patient_pathology_patient_rule_path(patient_id: patient.id, id: patient_rule.id)

      expect(response).to have_http_status(:redirect)
      expect(patient_rule_exists).to be_falsey

      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end
end
