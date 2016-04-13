require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = RecentResultsPresenter.new
        service = ViewObservations.new(@patient.observations, presenter)
        service.call(params)

        render :index, locals: {
          rows: presenter.view_model,
          paginator: presenter.paginator,
          table: HTMLRecentTableView.new(self.view_context)
        }
      end
    end
  end
end
