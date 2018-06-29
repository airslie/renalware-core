# frozen_string_literal: true

require_dependency "renalware/accesses"
require "attr_extras"

module Renalware
  module Accesses
    class DashboardPresenter
      attr_reader_initialize :patient

      def profiles
        @profiles ||= CollectionPresenter.new(
          patient.profiles.past_and_future.ordered,
          ProfilePresenter
        )
      end

      def plans
        @plans ||= CollectionPresenter.new(
          patient.plans.historical.ordered,
          PlanPresenter
        )
      end

      def procedures
        @procedures ||= CollectionPresenter.new(
          patient.procedures.ordered,
          ProcedurePresenter
        )
      end

      def assessments
        @assessments ||= CollectionPresenter.new(
          patient.assessments.ordered,
          AssessmentPresenter
        )
      end

      def current_profile
        @current_profile ||= ProfilePresenter.new(patient.current_profile)
      end

      def current_plan
        @current_plan ||= ProfilePresenter.new(patient.current_plan)
      end
    end
  end
end
