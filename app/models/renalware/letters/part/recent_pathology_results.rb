require "renalware/letters/part"

# When rendered, the template in `to_partial_path` will be used, and our Part object here will be
# available in the partial as `recent_pathology_results`.
module Renalware
  module Letters
    class Part::RecentPathologyResults < Part
      delegate :each, :any?, :present?, to: :recent_pathology_results

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      private

      def recent_pathology_results
        @recent_pathology_results ||= find_recent_pathology_results
      end

      def find_recent_pathology_results
        check_letter
        range = Time.zone.at(1)..letter.pathology_timestamp
        Renalware::Pathology::CurrentObservationsForDescriptionsQuery.new(
          patient: patient,
          descriptions: Renalware::Letters::RelevantObservationDescription.all
        ).call.where(observed_at: range).reject{ |obs| obs.id.nil? }
      end

      def check_letter
        if letter.pathology_timestamp.blank?
          raise ArgumentError,
                "letter.pathology_timestamp cannot be nil when rendering letter pathology!"
        end
      end
    end
  end
end
