require_dependency "renalware/medications"

module Renalware
  module Medications
    class TreatableDeletedMedicationsQuery < TreatableMedicationsQuery
      def treatable_medications
        @treatable.medications.only_deleted
      end
    end
  end
end

