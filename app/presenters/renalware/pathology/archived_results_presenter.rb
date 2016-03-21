require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      def initialize(query, observation_description_codes)
        @query = query
        @observation_description_codes = observation_description_codes
      end

      def to_a
        grouped.map { |observed_at, observation_attrs| present_attrs(observed_at, observation_attrs) }
      end

      private

      def present_attrs(observed_at, observations)
        attrs = {"observed_on" => I18n.l(observed_at) }

        @observation_description_codes.each_with_object(attrs) do |code|
          observation = observations.detect { |observation| observation.description.code == code }
          attrs[code] = observation.try!(:result).to_s
        end
      end

      def grouped
        @query.group_by {|x| x.observed_at.to_date }
      end
    end
  end
end
