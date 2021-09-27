# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class SummaryPart < Renalware::SummaryPart
      def recent_events
        @recent_events ||= begin
          events = query
                    .call
                    .limit(Renalware.config.clinical_summary_max_events_to_display)
                    .ordered
          CollectionPresenter.new(events, EventPresenter)
        end
      end

      def query
        @query ||= EventQuery.new(patient: patient, query: query_params)
      end

      def search
        @search ||= query.search
      end

      def recent_events_count
        title_friendly_collection_count(
          actual: recent_events.size,
          total: patient.summary.events_count
        )
      end

      def query_params
        params.fetch(:q, {})
      end

      # AR::Relation#cache_key here will issue:
      #   SELECT COUNT(*) AS "size", MAX("events"."updated_at") AS timestamp
      #   FROM "events" WHERE "events"."patient_id" = 1
      # and use size and timestamp in the cache key.
      # We purposefully don't use the recent_events relation here as it has includes and a limit
      # and apart from being slower, using LIMIT in cache_key sql has been known to produce
      # inconsistent results.
      # We need to include the patient.cache_key otherwise if there are no events, the key will
      # be the same for other patients with no events.
      def cache_key
        [patient.cache_key, Events::Event.for_patient(patient).cache_key].join("~")
      end

      def to_partial_path
        "renalware/events/events/summary_part"
      end
    end
  end
end
