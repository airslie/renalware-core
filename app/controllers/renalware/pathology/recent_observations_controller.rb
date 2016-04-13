require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewRecentObservationsFactory.new.build(@patient).call(params)

        render :index, locals: {
          rows: presenter.present,
          paginator: presenter.paginator,
          table: HTMLRecentTableView.new(self.view_context)
        }
      end
    end
  end
end
