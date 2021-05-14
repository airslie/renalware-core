# frozen_string_literal: true

require_dependency "renalware/surveys"

module Renalware
  module Surveys
    class POSSComponent < ApplicationComponent
      include ToggleHelper

      rattr_initialize [:patient!]

      # Backed by a SQL view
      def rows
        @rows ||= POSSPivotedResponse.where(patient_id: patient.id)
      end

      def question_labels
        @question_labels ||= survey
          .questions
          .order(:position)
          .select(:code, :label, :label_abbrv)
          .each_with_object({}) { |q, hash| hash[q.code] = q.admin_label }
      end

      # Return data for charting
      def data_for_question_code(_code)
        Renalware::Surveys::Response
          .where(patient_id: patient.id, question_id: 1)
          .pluck(:answered_on, :value)
          .to_h
      end

      def column_headings
        @column_headings ||= begin
          headings = ["Date"]

          headings.concat(
            Renalware::Survey
            .find_by!(code: "prom")
            .questions
            .order(:position)
            .pluck(:label)
          )
          headings
        end
      end

      def survey
        @survey ||= Renalware::Surveys::Survey.find_by!(code: "prom")
      end
    end
  end
end
