require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationResultsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = HistoricalObservationResults::Presenter.new
        service = ViewObservationResults.new(@patient.observations, presenter)
        service.call(params)

        render :index, locals: {
          rows: presenter.view_model,
          paginator: presenter.paginator,
          table: HistoricalObservationResults::HTMLTableView.new(self.view_context)
        }
      end
    end
  end
end
