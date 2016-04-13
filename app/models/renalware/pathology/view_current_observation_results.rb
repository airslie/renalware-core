require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewCurrentObservationResults
      def initialize(observations, presenter, descriptions: default_descriptions)
        @observations = observations
        @descriptions = descriptions
        @presenter = presenter
      end

      def call(params={})
        results = []
        present(results)
      end

      private

      def present(results)
        @presenter.present(results)
      end

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
