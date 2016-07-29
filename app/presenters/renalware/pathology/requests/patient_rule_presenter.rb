require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class PatientRulePresenter < SimpleDelegator
        include ActionView::Helpers::TextHelper

        def self.present(patient_rules)
          patient_rules.map { |patient_rule| new patient_rule }
        end

        def to_s
          test_description.to_s + sample_description
        end

        private

        def sample_description
          if sample_type.present? && sample_number_bottles.present?
            " (#{sample_type}, #{sample_number_bottles_string})"
          elsif sample_type.present?
            " (#{sample_type})"
          elsif sample_number_bottles.present?
            " (#{sample_number_bottles_string})"
          else
            ""
          end
        end

        def sample_number_bottles_string
          pluralize(sample_number_bottles, "bottle")
        end
      end
    end
  end
end
