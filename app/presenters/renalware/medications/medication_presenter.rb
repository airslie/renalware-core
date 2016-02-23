require_dependency "renalware/medications"

module Renalware
  module Medications
    class MedicationPresenter < DumbDelegator
      def route_name
        if medication_route.name == 'Route: Other (Please specify in notes)'
          medication_route.full_name
        else
          medication_route.name
        end
      end

      def drug_types
        drug.drug_types.map(&:name).join(", ")
      end

      def provider
        ::I18n.t(super, scope: "enums.provider")
      end
    end
  end
end
