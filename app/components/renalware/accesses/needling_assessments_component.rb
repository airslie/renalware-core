# frozen_string_literal: true

module Renalware
  module Accesses
    class NeedlingAssessmentsComponent < ApplicationComponent
      CSS_COLOURS = {
        easy: "bg-green-600 text-white",
        moderate: "bg-yellow-400 text-black",
        hard: "bg-red-600 text-white"
      }.freeze

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

      def css_class_for_difficulty(diff)
        CSS_COLOURS.fetch(diff&.difficulty&.to_sym, nil)
      end

      def render?
        total_assessments_count > 0
      end

      private

      attr_reader :patient, :current_user, :display_count
    end
  end
end
