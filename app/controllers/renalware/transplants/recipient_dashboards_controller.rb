# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RecipientDashboardsController < BaseController
      def show
        authorize patient
        render locals: { dashboard: RecipientDashboardPresenter.new(patient) }
      end
    end
  end
end
