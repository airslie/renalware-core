require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionPresenter < DumbDelegator
      def route_name
        medication_route.other? ? route_description : medication_route.name
      end

      def drug_types
        drug.drug_types.map(&:name).join(", ")
      end

      def provider
        ::I18n.t(super, scope: "enums.provider")
      end

      def terminated_by
        updated_by.full_name if terminated?
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
