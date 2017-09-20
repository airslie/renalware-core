require "renalware/admissions"

module Renalware
  module Admissions
    class RequestsController < BaseController

      def index
        requests = Request.all
        authorize requests
        render locals: { requests: requests }
      end

      def new
        request = Request.new(patient: patient)
        authorize request
        render_new(request)
      end

      def create
        request = Request.new(request_params)
        authorize request
        unless request.save_by(current_user)
          return render_new(request)
        end
      end

      private

      def patient
        Patient.find(params[:patient_id])
      end

      def render_new(request)
        render :new, locals: {
          request: request,
          reasons: RequestReason.ordered.pluck(:description, :id)
        }, layout: false
      end

      def request_params
        params
          .require(:admissions_request)
          .permit(:patient_id, :reason_id)
      end
    end
  end
end
