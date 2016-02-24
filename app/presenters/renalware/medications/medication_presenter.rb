require_dependency "renalware/medications"

module Renalware
  module Medications
    class MedicationPresenter < DumbDelegator
      def route_name
        ::I18n.t(
          medication_route.code.downcase,
          scope: "medications.routes.form.prompt",
          default: medication_route.name
        )
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
