require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class PatientRulePresenter < SimpleDelegator
      def to_s
        str = test_description || ""
        str +=
          if sample_type.present? && sample_number_bottles.present?
            " (#{sample_type}, #{sample_number_bottles_string})"
          elsif sample_type.present?
            " (#{sample_type})"
          elsif sample_number_bottles.present?
            " (#{sample_number_bottles_string})"
          else
            ""
          end
        str
      end

      private

      def sample_number_bottles_string
        bottle = "bottle"
        unit =
          if sample_number_bottles > 1
            bottle.pluralize
          else
            bottle
          end

        "#{sample_number_bottles} #{unit}"
      end
    end
  end
end
