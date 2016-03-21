require_dependency "renalware/patients"

module Renalware
  module Patients
    class MessageListener
      def message_processed(message_payload)
        patient_params = parse_patient_params(message_payload)
        create_patient(patient_params)
      end

      private

      def parse_patient_params(message_payload)
        MessageParamParser.new.parse(message_payload)
      end

      def create_patient(params)
        CreatePatient.new.call(params)
      end
    end
  end
end
