require_dependency "renalware/patients"

module Renalware
  module Patients
    class UpdatePatient
      def call(patient_id, params)
        patient = find_patient(patient_id)

        patient.update(params)
      end

      private

      def find_patient(id)
        Patient.find(id)
      end
    end
  end
end
