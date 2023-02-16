# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Jobs::SendMessageJob < Jobs::TransferOfCareJob
      class PatientHasNoPracticeError < StandardError; end
      class GPNotInRecipientsError < StandardError; end

      def perform(transmission)
        Perform.new(transmission).call
      end

      class Perform
        pattr_initialize :transmission
        delegate :letter, to: :transmission
        delegate :patient, to: :letter
        delegate :primary_care_physician, :practice, to: :patient, allow_nil: true

        def call
          validate_arguments
          lookup_mesh_mailbox_for_practice_if_missing
          build_payload_and_send_message
        end

        private

        def validate_arguments
          raise(GPNotInRecipientsError, "letter should not be sent") unless gp_is_a_recipient?
          raise PatientHasNoPracticeError if practice.nil?
        end

        def gp_is_a_recipient?
          letter.recipients.any?(&:primary_care_physician?) # only ever zero or one gp recipient
        end

        # EndpointlookupJob will save the mailbox id to the practice if one found.
        def lookup_mesh_mailbox_for_practice_if_missing
          if practice.toc_mesh_mailbox_id.blank?
            Jobs::EndpointlookupJob.perform_now(practice, transmission_id: transmission.id)
          end
        end

        def build_payload_and_send_message
          API::LogOperation.new(:send_message).call(transmission_id: transmission.id) do |operation|
            operation.payload = BuildPayload.call(
              transmission: transmission,
              transaction_uuid: operation.uuid
            )
            API::Client.send_message(operation.payload, operation_uuid: operation.uuid)
          end
        end
      end
    end
  end
end
