require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewCurrentObservationResults
      def initialize(patient, presenter, descriptions: default_descriptions)
        @patient = patient
        @descriptions = descriptions
        @presenter = presenter
      end

      def call(_params={})
        results = find_current_observations_for_descriptions
        sorted_results = sort_results(results)
        present(sorted_results)
      end

      private

      def find_current_observations_for_descriptions
        CurrentObservationsForDescriptionsQuery
          .new(patient: @patient, descriptions: @descriptions)
          .call
      end

      def sort_results(results)
        @descriptions
          .map do |description|
            results.detect {|result| result.description_code == description.code }
          end
          .compact
      end

      def present(results)
        @presenter.present(results)
      end

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
