require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewHistoricalObservationsFactory.new.build(@patient).call

        render :index, locals: {
          rows: presenter.present,
          number_of_records: presenter.limit
        }
      end
    end
  end
end
