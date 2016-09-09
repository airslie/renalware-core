require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardsController < BaseController
      skip_after_action :verify_authorized

      def show
        dashboard = DashboardPresenter.new(current_user)

        render :show, locals: {
          user: current_user,
          letters: dashboard.draft_letters,
          bookmarks: dashboard.bookmarked_patients
        }
      end
    end
  end
end
