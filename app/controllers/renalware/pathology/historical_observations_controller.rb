require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewHistoricalObservationsFactory.new
          .build(@patient.observations)
          .call(params)

        render :index, locals: {
          rows: presenter.present,
          paginator: presenter.paginator,
          table: HTMLHistoricalTableView.new(self.view_context)
        }
      end
    end
  end
end
