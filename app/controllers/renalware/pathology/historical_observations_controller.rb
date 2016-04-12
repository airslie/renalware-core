require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewHistoricalObservationsFactory.new.build(@patient).call(params)

        render :index, locals: {
          rows: presenter.present,
          paginator: presenter.paginator
        }
      end
    end
  end
end
