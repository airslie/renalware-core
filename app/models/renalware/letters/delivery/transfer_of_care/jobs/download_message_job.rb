# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Jobs::DownloadMessageJob < Jobs::TransferOfCareJob
      # An example MESH message id is 20230315095843558004_7C0785
      def perform(message_id)
        Operation.transaction do
          download_operation, send_message_operation = download_message(message_id)
          acknowledge_message(message_id, download_operation, send_message_operation)

          if send_message_operation
            transmission = send_message_operation.transmission
            if transmission.successful_inf_and_bus_responses?
              transmission.update!(status: :success)
            end
          end
        end
      end

      # rubocop:disable Metrics/MethodLength
      def download_message(message_id)
        download_operation = nil
        send_message_operation = nil
        API::LogOperation.call(
          :download_message,
          mesh_message_id: message_id
        ) do |operation|
          download_operation = operation
          API::Client.download_message(message_id).tap do |response|
            local_id = response.headers["mex-localid"]
            if local_id.present? # e.g. "busAck-736ed503-bcd1-4b66-97ba-de8b51f00123"
              send_operation_operation_uuid = local_id.split("Ack-").last
              send_message_operation = Operation.find_by!(uuid: send_operation_operation_uuid)
              operation.update!(
                parent_id: send_message_operation&.id,
                transmission_id: send_message_operation&.transmission_id
              )
            end
          end
        end

        # Update the transmission with any error, unless status is already error
        if send_message_operation &&
           !download_operation.success? &&
           send_message_operation.transmission.status != "failure"
          send_message_operation.transmission.update!(status: :failure)
        end
        [download_operation, send_message_operation]
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def acknowledge_message(message_id, download_operation, send_message_operation)
        API::LogOperation.call(
          :acknowledge_message,
          mesh_message_id: message_id,
          parent: download_operation
        ) do |operation|
          API::Client.acknowledge_message(message_id).tap do
            if send_message_operation.present?
              operation.update!(
                parent_id: send_message_operation.id,
                transmission_id: send_message_operation.transmission_id
              )
            end
          end
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
