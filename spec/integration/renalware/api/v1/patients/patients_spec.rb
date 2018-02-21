require "rails_helper"
require "devise"

RSpec.describe "API request for a single patient JSON document", type: :feature do
  include PatientsSpecHelper

  let(:json) { JSON.parse(page.body) }
  let(:patient) { create(:patient, local_patient_id: "123") }
  let(:user) { create(:user, username: "aaaaa", authentication_token: "wWsSmmHywhYMWPM6e9ib") }

  describe "rendering json for a patient" do
    context "when no authorisation credentials passed in the query string" do
      it "forbids access to the resource" do
        visit api_v1_patient_path(id: patient.local_patient_id)
        expect(page.status_code).to eq(401)
        expect(json["error"]).to match("You need to sign in or sign up before continuing.")
      end
    end

    it "renders patient json" do
      visit api_v1_patient_path(
        id: patient.local_patient_id,
        username: user.username,
        token: user.authentication_token
      )

      expect(page.status_code).to eq(200)

      expect(json).to eq(
        {
          "nhs_number" => patient.nhs_number,
          "secure_id" => patient.secure_id,
          "legacy_patient_id" => patient.legacy_patient_id,
          "local_patient_id" => patient.local_patient_id,
          "local_patient_id_2" => patient.local_patient_id_2,
          "local_patient_id_3" => patient.local_patient_id_3,
          "local_patient_id_4" => patient.local_patient_id_4,
          "local_patient_id_5" => patient.local_patient_id_5,
          "title" => patient.title,
          "given_name" => patient.given_name,
          "family_name" => patient.family_name,
          "born_on" => patient.born_on.to_s,
          "died_on" => patient.died_on&.to_s,
          "sex" => patient.sex&.code,
          "ethnicity" => patient.ethnicity&.code,
          "medications_url" => api_v1_patient_medications_prescriptions_url(patient_id: patient),
          "hd_profile_url" => api_v1_patient_hd_current_profile_url(patient_id: patient)
        }
      )
    end
  end
end
