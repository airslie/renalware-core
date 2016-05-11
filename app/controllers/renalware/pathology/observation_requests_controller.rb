require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequestsController < Pathology::BaseController
      before_filter :load_patient

      def index
        @observation_requests = @patient.observation_requests
          .page(params[:page])
          .includes(:description)
          .ordered
      end
    end
  end
end
