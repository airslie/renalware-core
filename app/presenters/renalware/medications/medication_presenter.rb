require_dependency "renalware/medications"

module Renalware
  module Medications
    class MedicationPresenter < DumbDelegator
      def route_name
        if medication_route.other?
          "Route: Other (Refer to medication notes)"
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
