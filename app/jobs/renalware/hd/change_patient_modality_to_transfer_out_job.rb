# frozen_string_literal: true

module Renalware
  module HD
    # Change modality of stale HD patients with no hospital unit to Transfer Out.
    class ChangePatientModalityToTransferOutJob < ApplicationJob
      class ModalityChangeError < StandardError; end

      # rubocop:disable Metrics/MethodLength
      def perform
        System::APILog.with_log("Transfer Out stale HD patients") do |log|
          results = PatientsHavingNoHospitalUnitAndNoRecentSessionQuery.call
          results.each do |result|
            patient = Patient.find(result[:patient_id])
            result = change_modality_to_transfer_out(patient, result[:last_session_at])
            if result.success?
              log.records_added += 1
              next
            end

            next if modality_change_failed_because_curr_modality_more_recent_than_last_session?(
              result
            )

            raise ModalityChangeError, result.object.errors.full_messages.to_sentence
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      def change_modality_to_transfer_out(patient, last_session_at)
        Renalware::Modalities::ChangePatientModality
          .new(patient:, user: system_user)
          .broadcasting_to_configured_subscribers
          .call(
            description_id: transfer_out_modality_description.id,
            started_on: last_session_at + 31.days,
            notes: "Programmatic Transfer Out all HD patients without a hospital unit and " \
                   "last HD session more than a month ago"
          )
      end

      def modality_change_failed_because_curr_modality_more_recent_than_last_session?(result)
        result.failure? && result.object.errors.key?(:started_on)
      end

      def transfer_out_modality_description
        @transfer_out_modality_description ||=
          Renalware::Modalities::Description.find_by!(code: "transfer_out")
      end

      def system_user = @system_user ||= Renalware::SystemUser.find
    end
  end
end
