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

      def cache_key
        Events::Event.for_patient(patient).maximum(:updated_at)
      end

      def to_partial_path
        "renalware/events/events/summary_part"
      end

      # def cache_key
      #   Events::Event.for_patient(patient).maximum(:updated_at)
      # end
    end
  end
end
