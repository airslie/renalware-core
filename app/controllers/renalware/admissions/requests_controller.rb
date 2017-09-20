require "renalware/admissions"

module Renalware
  module Admissions
    class RequestsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        requests = Request.ordered.all.page(page).per(per_page)
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

      def sort
        authorize Request, :sort?
        ids = params["admissions_request"]
        Request.sort(ids)
        render json: ids
      end

      private

      def patient
        Patient.find(params[:patient_id])
      end

      def render_new(request)
        render :new, locals: {
          request: request,
          reasons: RequestReason.ordered.pluck(:description, :id),
          hospital_units: Hospitals::Unit.ordered.pluck(:name, :id)
        }, layout: false
      end

      def request_params
        params
          .require(:admissions_request)
          .permit(:patient_id, :reason_id, :notes, :hospital_unit_id)
      end
    end
  end
end
