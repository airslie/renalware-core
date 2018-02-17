require_dependency "renalware/events"

module Renalware
  module Events
    class SummaryPart < Renalware::SummaryPart
      def recent_events
        @recent_events ||= begin
          Events::Event.includes([:created_by, :event_type])
                       .for_patient(patient)
                       .limit(Renalware.config.clinical_summary_max_events_to_display)
                       .ordered
        end
      end

      def recent_events_count
        title_friendly_collection_count(
          actual: recent_events.size,
          total: patient.summary.events_count
        )
      end

      # We construct our cache_key from:
      # - the name of our partial
      # - patient id (important!)
      # - the current count of events - this will decrement when a letter is deleted thus
      #   invalidating our cache (relying solely on maximum(:updated_at) would not catch this).
      #   While there is currently no means of deleting an event, if one is removed in the database
      #   we will still invalidate the cache correctly.
      # - the max updated_at so we catch any edits (or new events, though that is also captured
      #   by including events_count above).
      def cache_key
        [
          to_partial_path,
          patient.id,
          patient.summary.events_count,
          date_formatted_for_cache(max_updated_at)
        ].join(":")
      end

      def to_partial_path
        "renalware/events/events/summary_part"
      end

      def max_updated_at
        Events::Event.for_patient(patient).maximum(:updated_at)
      end
    end
  end
end
