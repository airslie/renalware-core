require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        render locals: {
          dashboard: DashboardPresenter.new(@patient, view_context)
        }
      end
    end
  end
end
