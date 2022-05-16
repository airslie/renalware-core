# frozen_string_literal: true

module Renalware
  module Accesses
    class NeedlingAssessmentsComponent < ApplicationComponent
      def initialize(current_user:, patient:, display_count: 3)
        @current_user = current_user
        @patient = Accesses.cast_patient(patient)
        @display_count = display_count
        super
      end

      def assessments
        @assessments ||= patient.needling_assessments.limit(display_count)
      end

      def total_assessments_count
        @total_assessments_count ||= patient.needling_assessments.count
      end

      def assessments_count
        assessments.size
      end

      def render?
        total_assessments_count > 0
      end

      private

      attr_reader :patient, :current_user, :display_count
    end
  end
end
