require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, type: :model do

    def configure_patient_identifier_map
      Renalware.configure do |config|
        config.patient_hospital_identifier_map = {
          HOSP1: :local_patient_id,
          HOSP2: :local_patient_id_2,
          HOSP3: :local_patient_id_3,
          HOSP4: :local_patient_id_4,
          HOSP5: :local_patient_id_5
        }
      end
    end

    describe "#local_patient_id" do
      it "resolves correctly using the patient_hospital_identifier_map" do
        configure_patient_identifier_map
        patient = build(:patient,
                         local_patient_id: "",
                         local_patient_id_2: "",
                         local_patient_id_3: nil,
                         local_patient_id_4: "LP4")

        expect(patient.patient_hospital_id).to eq("LP4")
        expect(patient.patient_hospital_id_name).to eq(:HOSP4)
      end
    end
  end
end
