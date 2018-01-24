require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      before_action :load_patient

      def show
        render locals: { dashboard: DonorDashboardPresenter.new(patient) }
      end
    end
  end
end
