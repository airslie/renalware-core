require_dependency "renalware/medications"

module Renalware
  module Medications
    class TreatableHistoricalMedicationsQuery < TreatableMedicationsQuery
      def treatable_medications
        @treatable.medications.terminated
      end
    end
  end
end

