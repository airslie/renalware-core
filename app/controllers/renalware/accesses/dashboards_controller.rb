require "collection_presenter"

module Renalware
  module Accesses
    class DashboardsController < Accesses::BaseController
      before_action :load_patient

      # TODO: Wrap these variables in a DashboardPresenter
      def show
        procedures = @patient.procedures.ordered
        profiles = @patient.profiles.past_and_future.ordered
        plans = @patient.plans.ordered
        assessments = @patient.assessments.ordered

        @profiles = CollectionPresenter.new(profiles, ProfilePresenter)
        @plans = CollectionPresenter.new(plans, PlanPresenter)
        @procedures = CollectionPresenter.new(procedures, ProcedurePresenter)
        @assessments = CollectionPresenter.new(assessments, AssessmentPresenter)
        @current_profile = ProfilePresenter.new(@patient.current_profile)
      end
    end
  end
end
