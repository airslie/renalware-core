module Renalware
  module Letters::Transports
    module Mesh
      class DownloadMessageJob < ApplicationJob
        queue_as :mesh
        queue_with_priority 10

        # A MESH message id looks like this: 20230315095843558004_7C0785
        def perform(message_id)
          Mesh::Operation.transaction do
            download_operation, send_message_operation = download_message(message_id)
            acknowledge_message(message_id, download_operation, send_message_operation)
          end
        end

        # rubocop:disable Metrics/MethodLength
        def download_message(message_id)
          download_operation = nil
          send_message_operation = nil
          API::LogOperation.call(:download_message, mesh_message_id: message_id) do |operation|
            download_operation = operation
            API::Client.download_message(message_id).tap do |response|
              # Load response xml and get the uuid of our send_message request
              # from Bundle/entry/resource/MessageHeader/response/identifier/@value
              send_operation_operation_uuid =
                Letters::Transports::Mesh::API::ITK3Response.new(response).request_uuid
              if send_operation_operation_uuid.present?
                send_message_operation = Mesh::Operation.find_by!(
                  uuid: send_operation_operation_uuid
                )
                operation.update!(
                  parent_id: send_message_operation&.id,
                  transmission_id: send_message_operation&.transmission_id
                )

                operation.transmission.update!(
                  sent_to_practice_ods_code: response.headers["mex-from-ods"]
                )
              end
            end
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

        private

        def sent_to_practice_ods_code(operation)
          return unless operation&.response_headers

          operation.response_headers["mex-from-ods"]
        end
      end
    end
  end
end
