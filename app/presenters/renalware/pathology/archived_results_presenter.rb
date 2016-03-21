require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      def initialize(query, observation_descriptions)
        @query = query
        @observation_descriptions = observation_descriptions
      end

      def to_a
        grouped.map { |observed_at, observation_attrs| present_attrs(observed_at, observation_attrs) }
      end

      private

      def present_attrs(observed_at, observations)
        attrs = {"observed_on" => I18n.l(observed_at) }

        @observation_descriptions.each_with_object(attrs) do |description|
          observation = observations.detect { |observation| observation.description == description }
          attrs[description.code] = observation.try!(:result).to_s
        end
      end

      def grouped
        @query.group_by {|x| x.observed_at.to_date }
      end
    end
  end
end
