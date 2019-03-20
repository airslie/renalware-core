# frozen_string_literal: true

require_dependency "renalware/patients"

#
# When subscribed to HL7 `message_arrived` messages, gets notified of incoming HL7 messages
#
module Renalware
  module Patients
    class MessageListener
      def message_arrived(hl7_message:, **)
        return unless hl7_message.adt?
      end
    end
  end
end
