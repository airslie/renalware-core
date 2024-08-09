# frozen_string_literal: true

module Renalware
  module Letters::Transports
    module Mesh
      # Runs periodically against state=pending transmissions, to:
      # - mark them as complete when we have a successful inf and bus response
      # - mark as failed if insufficient responses returned after a period of time
      # - .. more to add here no doubt
      #
      # Find all pending transmissions with two download_operations and update the
      # status accordingly. Note that if an operation fails, it updates the parent transmission
      # status to failure, so here we only need to worry about pending transmissions with
      # two successful operations.
      class ReconcileTransmissionOperationsJob < ApplicationJob
        queue_as :mesh
        queue_with_priority 5

        def perform
          mark_pending_as_succeeded_if_inf_and_bus_operations_were_successful
          mark_pending_as_failed_if_response_window_elapsed
        end

        private

        def mark_pending_as_succeeded_if_inf_and_bus_operations_were_successful
          Transmission
            .where(id: pending_transmission_ids_with_two_successful_download_operations)
            .find_each do |transmission|
              transmission.update!(status: "success")
              transmission
                .letter
                .update_columns(gp_send_status: :success, updated_at: Time.zone.now)
            end
        end

        def mark_pending_as_failed_if_response_window_elapsed
          # need to think about this one a bit
        end

        # rubocop:disable Metrics/MethodLength
        def pending_transmission_ids_with_two_successful_download_operations
          sql = <<-SQL.squish
            select lmt.id from letter_mesh_transmissions lmt
            where
              lmt.status = 'pending'
              and exists(
                select 1 from letter_mesh_operations lmo
                  where
                    lmo.transmission_id = lmt.id
                    and lmo.action = 'download_message'
                    and lmo.itk3_response_type = 'bus'
                    and lmo.itk3_operation_outcome_code = '30001'
                )
              and exists(
                select 1 from letter_mesh_operations lmo
                  where
                    lmo.transmission_id = lmt.id
                    and lmo.action = 'download_message'
                    and lmo.itk3_response_type = 'inf'
                    and lmo.itk3_operation_outcome_code = '20013'
            );
          SQL

          ActiveRecord::Base.connection.execute(sql).values.flatten
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
