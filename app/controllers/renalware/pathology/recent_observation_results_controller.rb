require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationResultsController < Pathology::BaseController
      include Renalware::Concerns::Pageable
      before_action :load_patient

      def index
        observations_table = CreateObservationsGroupedByDateTable.new(
          patient: patient,
          observation_descriptions: ObservationDescription.in_display_order,
          page: page || 1,
          per_page: per_page || 100
        ).call
        render :index, locals: { table: observations_table }
      end
    end
  end
end
