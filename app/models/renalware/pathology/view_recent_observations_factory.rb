require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewRecentObservationsFactory
      def build(observations, descriptions: default_descriptions)
        ViewObservations.new(observations,
          descriptions: descriptions,
          presenter_factory: RecentResultsPresenter
        )
      end

      private

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
