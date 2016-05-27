require "rails_helper"

RSpec::Matchers.define :match_document do |expected|
  match do |actual|
    expected.each do |key, value|
      return false if actual.send(key.to_sym) != expected[key]
    end
    true
  end
end

RSpec.describe "Managing patients", type: :request do
  let(:patient) { create(:patient) }

  describe "GET new" do
    it "responds with a form" do
      get new_patient_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      let(:religion) { create(:patients_religion) }
      let(:language) { create(:patients_language) }

      let(:document) do
        {
          interpreter_notes: "asfdasfd",
          admin_notes: "zxcvzxvczcxv",
          special_needs_notes: "qwerwqerqwer",
        }
      end

      let(:patient_attributes) do
        attributes_for(:patient).merge(
          religion_id: religion.id, language_id: language.id, document: document
        )
      end

      it "creates a new record" do
        post patients_path, patient: patient_attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patient.exists?(patient_attributes)).to be_truthy

        created_patient = Renalware::Patient.find_by(patient_attributes)
        expect(created_patient.created_by).to eq(@current_user)
        expect(created_patient.updated_by).to eq(@current_user)

        created_patient = Renalware::Patient.find_by(attributes)
        expect(created_patient.document).to match_document(document)

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = {given_name: ""}
        post patients_path, patient: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_patient_path(patient)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = {given_name: "My Edited Patient"}
        patch patient_path(patient), patient: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patient.exists?(attributes)).to be_truthy

        updated_patient = Renalware::Patient.find_by(attributes)
        expect(updated_patient.updated_by).to eq(@current_user)

        follow_redirect!

        updated_patient = Renalware::Patient.find_by(attributes)
        expect(updated_patient.updated_by).to eq(@current_user)

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = {given_name: ""}
        patch patient_path(patient), patient: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end
end
