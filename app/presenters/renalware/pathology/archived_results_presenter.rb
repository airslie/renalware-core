require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      def initialize(records, observation_descriptions)
        @records = records
        @observation_descriptions = observation_descriptions
      end

      def rows
        results.map(&:values)
      end

      def to_a
        results
      end

      private

      def results
        @results ||= grouped.map do |observed_at, observation_attrs|
          present_attrs(observed_at, observation_attrs)
        end
      end

      def grouped
        @records.group_by {|record| record.observed_at.to_date }
      end

      def present_attrs(observed_at, observations)
        attrs = { "observed_on" => I18n.l(observed_at) }

        @observation_descriptions.each_with_object(attrs) do |description|
          observation = observations.detect { |observation| observation.description == description }
          attrs[description.code] = observation.try!(:result).to_s
        end
      end
    end
  end
end
