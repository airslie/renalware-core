# frozen_string_literal: true

require_dependency "renalware/pathology"

#
# When subscribed to HL7 `oru_message_arrived` messages, gets notified of incoming HL7 messages.
# Here we are interested only in AKI path results
#
module Renalware
  module Pathology
    module Ingestion
      class AKIListener
        class MessageDecorator
          pattr_initialize :hl7_message
          AKI_CODE = "AKI"

          # Return the first AKI score found in any OBR in the message
          def aki_score
            hl7_message
              .observation_requests
              .flat_map(&:observations)
              .detect { |obx| obx.identifier == AKI_CODE }
              &.value.to_f
          end
        end

        # If the ORU messages has an AKI score then add the patient to RW is they are not already,
        # and give them the AKI modality.
        # NOTE: We are already inside a transaction here
        def oru_message_arrived(args)
          hl7_message = args[:hl7_message]
          aki_score = MessageDecorator.new(hl7_message).aki_score
          return unless aki_score > 0

          patient = add_patient_if_not_exists(hl7_message)
          assign_aki_modality_to(patient) if patient.current_modality.blank?

          current_modality = patient.current_modality
          return if current_modality && %w(hd pd).include?(current_modality.description.code)

          has_recent_aki_alert = Renal::AKIAlert
            .where(patient_id: patient.id)
            .where("created_at >= ?", 2.days.ago)
            .exists?

          unless has_recent_aki_alert
            Renal::AKIAlert.create!(
              patient_id: patient.id,
              max_aki: aki_score
            )
          end
        end

        private

        def assign_aki_modality_to(patient)
          cmd = Modalities::ChangePatientModality.new(patient: patient, user: SystemUser.find)
          cmd.call(description: aki_modality_description, started_on: Time.zone.now)
        end

        def aki_modality_description
          Renalware::Modalities::Description.find_by!("code ILIKE ?", "aki")
        end

        def add_patient_if_not_exists(hl7_message)
          Patients::Ingestion::Commands::AddPatient.call(hl7_message)
        end
      end
    end
  end
end
