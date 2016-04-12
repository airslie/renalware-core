require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewHistoricalObservationsFactory
      def build(patient, descriptions: default_descriptions)
        ViewObservations.new(
          patient, descriptions: descriptions, presenter_factory: HistoricalResultsPresenter)
      end

      private

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
