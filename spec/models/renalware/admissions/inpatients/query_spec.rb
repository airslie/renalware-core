require "rails_helper"

module Renalware
  describe Admissions::Inpatients::Query do
    it "returns all inpatients if no options passed" do
      inpatient = create(:admissions_inpatient)

      inpatients = described_class.call({})

      expect(inpatients).to eq([inpatient])
    end

    it "filters by name" do
      patient = create(:patient, family_name: "Jones", given_name: "Tom")
      inpatient = create(:admissions_inpatient, patient: patient)
      create(:admissions_inpatient) # other inpatient

      inpatients = described_class.call({ identity_match: "JOn to" })

      expect(inpatients).to eq([inpatient])
    end

    it "filters by hospital unit" do
      unit = create(:hospital_unit)
      inpatient = create(:admissions_inpatient, hospital_unit: unit)
      create(:admissions_inpatient) # other inpatient

      inpatients = described_class.call({ hospital_unit_id_eq: unit.id })

      expect(inpatients).to eq([inpatient])
    end

    it "filters by hospital ward" do
      ward = create(:hospital_ward)
      inpatient = create(:admissions_inpatient, hospital_ward: ward)
      create(:admissions_inpatient) # other inpatient

      inpatients = described_class.call({ hospital_ward_id_eq: ward.id })

      expect(inpatients).to eq([inpatient])
    end
  end
end
