require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class PatientRulePresenter < SimpleDelegator
      include ActionView::Helpers::TextHelper

      def to_s
        (test_description || "") + sample_description
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
