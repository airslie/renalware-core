# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class SurveyResponse < ApplicationRecord
      belongs_to :question, class_name: "SurveyQuestion"
      validates :patient_id, presence: true
      validates :answered_on, presence: true
      validates :question, presence: true
      validate :value_is_in_range

      private

      def value_is_in_range
        return if question&.validation_regex.blank?

        unless value =~ /#{question.validation_regex}/
          errors.add(
            :value,
            "(#{value}) must comply to regular expression /#{question.validation_regex}/"
          )
        end
      end
    end
  end
end
