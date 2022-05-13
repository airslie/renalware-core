# frozen_string_literal: true

module Renalware
  module Accesses
    class NeedlingDifficultiesComponent < ApplicationComponent
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

      def difficulties
        @difficulties ||= patient.needling_difficulties.limit(display_count)
      end

      def total_difficulties_count
        @total_difficulties_count ||= patient.needling_difficulties.count
      end

      def difficulties_count
        difficulties.size
      end

      def css_class_for_difficulty(diff)
        CSS_COLOURS.fetch(diff&.difficulty&.to_sym, nil)
      end

      private

      attr_reader :patient, :current_user, :display_count
    end
  end
end
