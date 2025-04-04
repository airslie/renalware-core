#
# When subscribed to HL7 `message_arrived` messages, gets notified of incoming HL7 messages
#
module Renalware
  module Patients
    module Ingestion
      class MessageListener
        # ADT = admission, discharge, transfer
        def adt_message_arrived(args)
          hl7_message = args[:hl7_message]
          return unless hl7_message.adt?

          command = Command.for(hl7_message)
          command.call
        end

        # ORM = order message
        def orm_message_arrived(args)
          hl7_message = args[:hl7_message]
          return unless hl7_message.orm?

          command = Command.for(hl7_message)
          patient = command.call

          store_concatenated_obx_segments_as_kv_pairs_into_admin_notes(hl7_message, patient)
        end

        private

        # The OBR segment could be something like 'OBR|1|5541473217^ORDERID||Refer to Renal (OP)|'
        # The OBX segments could be something like 'OBX|2|ST|TEXT2^TEXT2||VALUE2'
        # We want to store these in the patient's admin_notes field as a concatenated string
        # with the OBR segment as the title and the OBX segments as key value pairs
        # TODO: move to a custom command
        def store_concatenated_obx_segments_as_kv_pairs_into_admin_notes(hl7_message, patient)
          return if patient.blank?
          return if patient.document.admin_notes.present?

          title = hl7_message[:OBR].universal_service_id.split("^").first
          elements = [title]
          Array(hl7_message[:OBX]).each_with_object(elements) do |obx, arr|
            arr << [
              obx.observation_id.split("^").first,
              obx.observation_value
            ].join(": ")
          end

          patient.document.admin_notes = elements.join("\n")
          patient.save_by!(Renalware::SystemUser.find, validate: false)
        end
      end
    end
  end
end
