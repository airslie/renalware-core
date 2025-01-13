module Renalware
  module Patients
    module Ingestion
      #
      # Responsible for making commands to process messages based on the message type.
      #
      class CommandFactory
        def for(message)
          case message.action
          when :add_person_information    then make_add_patient(message)
          when :update_person_information then make_update_patient(message)
          when :admit_patient             then make_admit_patient(message)
          when :update_admission          then make_update_admission(message)
          when :cancel_admission          then make_cancel_admission(message)
          when :transfer_patient          then make_transfer_patient(message)
          when :discharge_patient         then make_discharge_patient(message)
          when :cancel_discharge          then make_cancel_discharge(message)
          else noop
          end
        end

        private

        def make_add_patient(message)       = Commands::UpdatePatient.new(message)
        def make_update_patient(message)    = Commands::UpdatePatient.new(message)
        def make_admit_patient(message)     = Commands::AdmitPatient.new(message)
        def make_update_admission(message)  = Commands::AdmitPatient.new(message)
        def make_cancel_admission(message)  = Commands::AdmitPatient.new(message)
        def make_transfer_patient(message)  = Commands::AdmitPatient.new(message)
        def make_discharge_patient(message) = Commands::AdmitPatient.new(message)
        def make_cancel_discharge(message)  = Commands::AdmitPatient.new(message)
        def noop                            = NullObject.instance
      end
    end
  end
end
