require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationResultsController < Pathology::BaseController
      before_filter :load_patient
      before_filter :load_bookmark

      def index
        table_view = HistoricalObservationResults::HTMLTableView.new(self.view_context)
        presenter = HistoricalObservationResults::Presenter.new
        service = ViewObservationResults.new(@patient.observations, presenter)
        service.call(params)

        render :index, locals: {
          rows: presenter.view_model,
          paginator: presenter.paginator,
          table: table_view
        }
      end
    end
  end
end
