# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      def show
        authorize patient
        render locals: { dashboard: DonorDashboardPresenter.new(patient) }
      end
    end
  end
end
