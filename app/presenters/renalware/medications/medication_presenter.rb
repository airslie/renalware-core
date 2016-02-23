require_dependency "renalware/medications"

module Renalware
  module Medications
    class MedicationPresenter < DumbDelegator
      def drug_types
        drug.drug_types.map(&:name).join(", ")
      end
    end
  end
end
