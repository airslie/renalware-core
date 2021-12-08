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
            aki_observation&.value.to_f
          end

          def aki_date
            aki_observation&.observation_date
          end

          def hospital_centre_id
            sending_facility = hl7_message[:MSH].sending_facility # eg RAJ01
            Hospitals::Centre.find_by(code: sending_facility)&.id
          end

          private

          def aki_observation
            @aki_observation ||= hl7_message
              .observation_requests
              .flat_map(&:observations)
              .detect { |obx| obx.identifier == AKI_CODE }
          end
        end

        # If the ORU messages has an AKI score then add the patient to RW is they are not already,
        # and give them the AKI modality.
        # NOTE: We are already inside a transaction here
        def oru_message_arrived(args)
          hl7_message = args[:hl7_message]
          aki = MessageDecorator.new(hl7_message)
          return unless aki.aki_score > 0

          patient = add_patient_if_not_exists(hl7_message)
          assign_aki_modality_to(patient) if patient.current_modality.blank?

          current_modality_code = patient.current_modality&.description&.code
          excluded_modalities = %w(hd pd low_clearance akcc)
          return if excluded_modalities.include?(current_modality_code)

          has_recent_aki_alert = Renal::AKIAlert
            .where(patient_id: patient.id)
            .where("created_at >= ?", 2.weeks.ago)
            .exists?

          pathset = ObservationSetPresenter.new(patient.current_observation_set)

          unless has_recent_aki_alert
            Renal::AKIAlert.create!(
              patient_id: patient.id,
              max_aki: aki.aki_score,
              aki_date: aki.aki_date,
              max_cre: pathset.cre_result,
              cre_date: pathset.cre_observed_at,
              hospital_centre_id: aki.hospital_centre_id
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
