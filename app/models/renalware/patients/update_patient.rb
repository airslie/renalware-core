require_dependency "renalware/patients"

module Renalware
  module Patients
    class UpdatePatient
      include Wisper::Publisher

      def self.build
        SubscriptionRegistry.instance.subscribe_listeners_to(self.new)
      end

      def call(patient_id, params)
        patient = find_patient(patient_id)

        if patient.update(params)
          broadcast(:update_patient_successful, patient)
        else
          broadcast(:update_patient_failed, patient)
        end
      end

      private

      def find_patient(id)
        Patient.find(id)
      end
    end
  end
end
