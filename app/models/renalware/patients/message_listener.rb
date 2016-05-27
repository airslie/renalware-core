require_dependency "renalware/patients"

module Renalware
  module Patients
    class MessageListener
      def message_processed(message_payload)
        patient_params = parse_patient_params(message_payload)
        system_user = find_system_user
        create_patient(patient_params, system_user)
      end

      private

      def parse_patient_params(message_payload)
        MessageParamParser.new.parse(message_payload)
      end

      def create_patient(params, user)
        IdempotentCreatePatient.new(user).call(params)
      end

      def find_system_user
        SystemUser.find
      end
    end
  end
end
