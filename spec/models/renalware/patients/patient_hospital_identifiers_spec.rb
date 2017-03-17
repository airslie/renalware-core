require "rails_helper"

module Renalware::Patients
  describe PatientHospitalIdentifiers do

    # This represents the order of preference of local_patient_ids database columns and also
    # their 'display names' for use e.g. in the patient banner
    def configure_patient_identifier_map
      Renalware.configure do |config|
        config.patient_hospital_identifier_map = {
          KCH: :local_patient_id,
          HOSP2: :local_patient_id_4,
          HOSP3: :local_patient_id_2,
          HOSP4: :local_patient_id_3,
          HOSP5: :local_patient_id_5
        }
      end
    end

    describe "#all" do
      it "lists local_patient_ids in use in the correct order" do
        configure_patient_identifier_map
        patient = build(:patient,
                         local_patient_id: "LP1",
                         local_patient_id_2: "",
                         local_patient_id_3: nil,
                         local_patient_id_4: "LP4",
                         local_patient_id_5: "LP5")

        expected = {
          KCH: "LP1",
          HOSP2: "LP4",
          HOSP5: "LP5"
        }
        expect(PatientHospitalIdentifiers.new(patient).all).to eq(expected)
      end

      it "returns an empty hash if the patient has no local_patient_ids" do
        configure_patient_identifier_map
        patient = build(:patient,
                         local_patient_id: nil,
                         local_patient_id_2: nil,
                         local_patient_id_3: nil,
                         local_patient_id_4: "",
                         local_patient_id_5: "")
        expect(PatientHospitalIdentifiers.new(patient).all).to eq({})
      end
    end

    describe "#id and #name" do
      it "returns the value of name of the topmost found local_patient_id in order of preference" do
        configure_patient_identifier_map
        patient = build(:patient,
                         local_patient_id: "",
                         local_patient_id_2: "",
                         local_patient_id_3: nil,
                         local_patient_id_4: "LP4",
                         local_patient_id_5: "LP5")

        identifiers = PatientHospitalIdentifiers.new(patient)
        expect(identifiers.id).to eq("LP4")
        expect(identifiers.patient_hospital_id).to eq("LP4")
        expect(identifiers.to_s).to eq("HOSP2: LP4")

        # see configure_local_patient_id_map
        # HOSP2 is mapped to local_patient_id_4 as the second-most preferred column
        expect(identifiers.name).to eq(:HOSP2)
        expect(identifiers.to_sym).to eq(:HOSP2)
        expect(identifiers.patient_hospital_id_name).to eq(:HOSP2)
      end

      context "when the patient has no local_patient_ids" do
        it ":id and :name return nil" do
          configure_patient_identifier_map
          patient = build(:patient,
                           local_patient_id: nil,
                           local_patient_id_2: nil,
                           local_patient_id_3: nil,
                           local_patient_id_4: "",
                           local_patient_id_5: "")

          identifiers = PatientHospitalIdentifiers.new(patient)
          expect(identifiers.id).to eq(nil)
          expect(identifiers.name).to eq(nil)
        end
      end
    end
  end
end
