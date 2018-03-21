# frozen_string_literal: true

require_dependency "renalware/low_clearance"

module Renalware
  module LowClearance
    class DashboardsController < LowClearance::BaseController
      def show
        authorize patient
        render :show, locals: {
          patient: patient,
          dashboard: dashboard_presenter
        }
      end

      private

      def dashboard_presenter
        DashboardPresenter.new(user: current_user, patient: patient)
      end
    end
  end
end
