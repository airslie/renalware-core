# frozen_string_literal: true

describe "Patient HD Search e.g. when adding patients to a slot" do
  include PatientsSpecHelper

  let(:hd_mod)  { create(:hd_modality_description) }
  let(:pd_mod)  { create(:pd_modality_description) }
  let(:user)    { create(:user) }
  let(:hd_pat1) { create_pat(given: "HDP1X", family: "HDP1Y", nhs: "4414733227", mod_desc: hd_mod) }
  let(:hd_pat2) { create_pat(given: "HDP2X", family: "HDP2Y", nhs: "7489724309", mod_desc: hd_mod) }
  let(:pd_pat)  { create_pat(given: "PDPx", family: "PDPy", nhs: "1408462818", mod_desc: pd_mod) }

  def create_pat(given:, family:, nhs:, mod_desc:)
    create(:patient, family_name: family, given_name: given, nhs_number: nhs).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: mod_desc,
        by: user
      )
    end
  end

  # How the json returned from the API should look for a single patient
  def patient_json(patient)
    {
      "id" => patient.id,
      "text" => patient.becomes(Renalware::Patient).to_s(:long)
    }
  end

  describe "dialysing_at_hospital" do
    it "returns [] when there are no HD patients" do
      pd_pat # no hd patients
      get renalware.hd_patients_dialysing_at_hospital_path(format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to be_empty
    end

    it "returns all HD patients" do
      hd_pat1
      pd_pat

      get renalware.hd_patients_dialysing_at_hospital_path(format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to eq([patient_json(hd_pat1)])
    end

    it "can filter by a search term which matches against e.g. name" do
      hd_pat1
      hd_pat2
      pd_pat

      get renalware.hd_patients_dialysing_at_hospital_path(format: :json, term: hd_pat2.family_name)

      expect(response).to be_successful
      expect(response.parsed_body).to eq([patient_json(hd_pat2)])
    end
  end

  describe "dialysing_at_unit"
end
