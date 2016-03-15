module World
  module Patients
    module Domain
      def expect_patient_to_be_created(expected_attributes)
        patient = fetch_patient_by_local_id(expected_attributes.fetch("local_patient_id"))

        expected_attributes.each do |attribute_name, attribute_value|
          expect(patient.attributes[attribute_name].to_s).to eq(attribute_value)
        end
      end

      def fetch_patient_by_local_id(local_id)
        Renalware::Patient.find_by(local_patient_id: local_id)
      end
    end
  end
end
