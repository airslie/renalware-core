# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DashboardsController < BaseController
      before_action :load_patient

      def show
        render locals: {
          dashboard: DashboardPresenter.new(patient, view_context, current_user)
        }
      end
    end
  end
end
