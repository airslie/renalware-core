require_dependency "renalware/patients"

module Renalware
  module Patients
    # Responsible for transforming an HL7 message payload into a params hash
    # that can be persisted by Patient.
    #
    class MessageParamParser
      def parse(message_payload)
        pi = message_payload.patient_identification

        {
          patient: {
            nhs_number: pi.external_id,
            local_patient_id: pi.internal_id,
            family_name: pi.family_name,
            given_name: pi.given_name,
            sex: pi.sex,
            born_on: Date.parse(pi.dob).to_s,
            by: system_user
          }
        }
      end

      private

      def system_user
        ::Renalware::SystemUser.find
      end
    end
  end
end
