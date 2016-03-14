require_dependency "renalware/patients"

module Renalware
  module Patients
    class MessageParamParser
      def parse(message_payload)
        pi = message_payload.patient_identification

        {
          patient: {
            local_patient_id: pi.internal_id,
            family_name: pi.family_name,
            given_name: pi.given_name,
            sex: pi.sex,
            born_on: Date.parse(pi.dob).to_s
          }
        }
      end
    end
  end
end
