module Renalware
  module Transplants
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        @registration = Registration.for_patient(params[:patient_id]).first_or_initialize
      end
    end
  end
end
