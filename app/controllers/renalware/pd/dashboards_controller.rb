require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class DashboardsController < BaseController
      before_action :load_patient

      def show
        render :show, locals: {
          patient: patient,
          dashboard: DashboardPresenter.new(patient)
        }
      end
    end
  end
end
