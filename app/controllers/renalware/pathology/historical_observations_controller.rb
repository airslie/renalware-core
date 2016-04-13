require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = HistoricalResultsPresenter.new
        service = ViewObservations.new(@patient.observations, presenter)
        service.call(params)

        render :index, locals: {
          rows: presenter.view_model,
          paginator: presenter.paginator,
          table: HTMLHistoricalTableView.new(self.view_context)
        }
      end
    end
  end
end
