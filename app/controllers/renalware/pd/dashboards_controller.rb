# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class DashboardsController < PD::BaseController
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
