module Renalware
  module Accesses
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        @current_profile = ProfilePresenter.new(@patient.current_profile)
        @profiles = @patient.profiles.past_and_future.ordered
        @procedures = @patient.procedures.ordered
        @assessments = @patient.assessments.ordered
      end
    end
  end
end
