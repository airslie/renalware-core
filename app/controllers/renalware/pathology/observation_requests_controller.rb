require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequestsController < Pathology::BaseController
      before_filter :load_patient

      def index
        observation_requests = @patient.observation_requests
          .page(params[:page])
          .includes(:description)
          .ordered

        render locals: {observation_requests: observation_requests, patient: @patient}
      end

      def show
        observation_request = @patient.observation_requests
          .includes(:description, observations: :description)
          .find(params[:id])

        render locals: {observation_request: observation_request, patient: @patient}
      end
    end
  end
end
