require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class PatientRulePresenter < SimpleDelegator
      def sample_number_bottles_string
        suffix = sample_number_bottles > 1 ? "s" : ""

        "#{sample_number_bottles} bottle#{suffix}"
      end
    end
  end
end
