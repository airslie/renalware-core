# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class DashboardsController < PD::BaseController
      skip_after_action :verify_policy_scoped

      def show
        authorize patient
        render :show, locals: {
          patient: patient,
          dashboard: DashboardPresenter.new(patient)
        }
      end
    end
  end
end
