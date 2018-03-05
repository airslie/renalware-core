require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationResultsController < Pathology::BaseController
      include Renalware::Concerns::Pageable
      before_action :load_patient

      def index
        observations_table = CreateObservationsGroupedByDateTable.new(
          patient: patient,
          observation_descriptions: ObservationDescription.in_display_order,
          page: page || 1,
          per_page: 25
        ).call
        render :index, locals: { table: observations_table }
      end
    end
  end
end
