require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardsController < BaseController
      def show
        authorize current_user
        render :show, locals: { user: current_user }
      end
    end
  end
end
