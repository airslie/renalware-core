require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationResultsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = RecentObservationResults::Presenter.new
        service = ViewObservationResults.new(@patient.observations, presenter)
        service.call(params)

        render :index, locals: {
          rows: presenter.view_model,
          paginator: presenter.paginator,
          table: RecentObservationResults::TableView.new(self.view_context)
        }
      end
    end
  end
end
