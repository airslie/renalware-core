require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionPresenter < DumbDelegator
      def route_code
        medication_route.other? ? route_description : medication_route.code
      end

      def drug_types
        drug.drug_types.map(&:name).join(", ")
      end

      def provider
        ::I18n.t(super, scope: "enums.provider")
      end

      def dose
        "#{dose_amount} #{translated_dose_unit}"
      end

      private

      def translated_dose_unit
        ::I18n.t(dose_unit, scope: "enumerize.renalware.medications.prescription.dose_unit")
      end
    end
  end
end
