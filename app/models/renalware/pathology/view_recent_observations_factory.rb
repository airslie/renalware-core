require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewRecentObservationsFactory
      def build(patient, descriptions: default_descriptions)
        ViewObservations.new(
          patient, descriptions: descriptions, presenter_factory: RecentResultsPresenter)
      end

      private

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
