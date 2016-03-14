require_dependency "renalware/patient"

module Renalware
  module Patients
    class CreatePatient
      def call(params)
        patient_params = params.fetch(:patient)
        local_patient_id = patient_params.fetch(:local_patient_id)

        create_patient_if_not_exist(patient_params, local_patient_id)
      end

      def create_patient_if_not_exist(patient_params, local_patient_id)
        ::Renalware::Patient.create_with(patient_params.merge(nhs_number: "TO-ADD-123"))
                            .find_or_create_by!(local_patient_id: local_patient_id)
      end
    end
  end
end
