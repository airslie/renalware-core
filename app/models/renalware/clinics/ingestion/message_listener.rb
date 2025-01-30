#
# When subscribed to HL7 `adt_message_arrived` messages, gets notified of incoming HL7 messages
#
module Renalware
  module Clinics
    module Ingestion
      class MessageListener
        def adt_message_arrived(args)
          hl7_message = args[:hl7_message]
          return unless hl7_message.adt? || hl7_message.siu?

          case hl7_message.action
          when :schedule_new_appointment then Commands::CreateOrUpdateAppointment.call(hl7_message)
          when :cancel_appointment then Commands::DeleteAppointment.call(hl7_message)
          else noop
          end
        end
        alias siu_message_arrived adt_message_arrived

        private

        def noop
          NullObject.instance
        end
      end
    end
  end
end
