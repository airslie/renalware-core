# frozen_string_literal: true

require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardsController < BaseController
      skip_after_action :verify_authorized
      skip_after_action :verify_policy_scoped

      def show
        render :show, locals: {
          dashboard: DashboardPresenter.new(current_user)
        }
      end
    end
  end
end
