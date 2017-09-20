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
        request = Request.new
        authorize request
        render_new(request)
      end

      def create
        request = Request.new(request_params)
        authorize request
        if request.save_by(current_user)
          redirect_to admissions_requests_path, notice: success_msg_for("admission request")
        else
          render_new(request)
        end
      end

      private

      def render_new(request)
        render :new, locals: { request: request }
      end

      def request_params
        params
          .require(:admissions_request)
          .permit(:patient_id, :reason_id)
      end
    end
  end
end
