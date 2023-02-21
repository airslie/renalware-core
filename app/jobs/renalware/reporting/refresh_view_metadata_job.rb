# frozen_string_literal: true

module Renalware
  module Reporting
    class RefreshViewMetadataJob < ApplicationJob
      queue_as :reporting
      queue_with_priority 1

      def perform(view_metadata)
        if view_metadata.materialized?
          refresh_materialized_view_associated_with_view_metadata(view_metadata)
          update_view_metadata_refreshment_date(view_metadata)
        else
          Rails.logger.warn \
            "Cannot refresh a view that is not materialized: #{view_metadata.view_name}"
        end
      end

      private

      def refresh_materialized_view_associated_with_view_metadata(view_metadata)
        Scenic.database.refresh_materialized_view(view_metadata.view_name,
                                                  concurrently: false,
                                                  cascade: false)
      end

      def update_view_metadata_refreshment_date(view_metadata)
        view_metadata.update!(materialized_view_refreshed_at: Time.zone.now)
      end
    end
  end
end
