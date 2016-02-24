require_dependency "renalware/medications"

module Renalware
  module Medications
    class TreatablePresenter < DumbDelegator
      def sortable?
        __getobj__.class == Patient
      end
    end
  end
end
