require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      def initialize(query)
        @query = query
      end

      def to_a
        grouped.map { |observed_at, observation_attrs| present_attrs(observed_at, observation_attrs) }
      end

      private

      def present_attrs(observed_at, observations)
        attrs = {"observed_on" => I18n.l(observed_at) }

        observations.each_with_object(attrs) do |observation|
          attrs[observation.description.code] = observation.result
        end
      end

      def grouped
        @query.group_by {|x| x.observed_at.to_date }
      end
    end
  end
end
