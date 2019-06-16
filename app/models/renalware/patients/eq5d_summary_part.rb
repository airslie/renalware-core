# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Patients
    class EQ5DSummaryPart < Renalware::SummaryPart
      def rows
        @rows ||= EQ5DPivotedResponse.where(patient_id: patient.id)
      end

      def question_labels
        survey
          .questions
          .order(:position)
          .select(:code, :label)
          .each_with_object({}) { |q, hash| hash[q.code] = q.label }
      end

      def data_for_question_code(_code)
        Renalware::Patients::SurveyResponse
          .where(patient_id: patient.id, question_id: 1)
          .pluck(:answered_on, :value)
          .to_h
      end

      def column_headings
        @column_headings ||= begin
          headings = ["Date"]

          headings.concat(
            Renalware::Patients::Survey
            .find_by!(name: "EQ5D-5L")
            .questions
            .order(:position)
            .pluck(:label)
          )
          headings
        end
      end

      def to_partial_path
        "renalware/patients/surveys/eq5d_summary_part"
      end

      def survey
        @survey ||= Renalware::Patients::Survey.find_by!(name: "EQ5D-5L")
      end
    end
  end
end
