require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewHistoricalObservations.new(@patient, description_codes).call

        render :index, locals: {
          rows: presenter.to_a,
          number_of_records: presenter.limit
        }
      end

      private

      def description_codes
        RelevantObservationDescription.new.to_a
      end
    end
  end
end
