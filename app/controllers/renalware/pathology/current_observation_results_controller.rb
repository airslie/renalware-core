require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CurrentObservationResultsController < Pathology::BaseController
      before_filter :load_patient

      def index
        table_view = CurrentObservationResults::HTMLTableView.new(self.view_context)
        presenter = CurrentObservationResults::Presenter.new
        service = ViewCurrentObservationResults.new(@patient, presenter)
        service.call

        render :index, locals: {
          rows: presenter.view_model,
          table: table_view
        }
      end
    end
  end
end
