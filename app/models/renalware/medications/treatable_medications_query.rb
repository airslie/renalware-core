require_dependency "renalware/medications"

module Renalware
  module Medications
    class TreatableMedicationsQuery
      def initialize(treatable:, search_params: nil)
        @treatable = treatable
        @search_params = search_params || {}
        @search_params.reverse_merge!(s: default_search_order)
      end

      def call
        search.result
      end

      def search
        treatable_medications.search(@search_params)
      end

      def treatable_medications
        @treatable.medications
      end

      private

      def default_search_order
        Medication.default_search_order
      end
    end
  end
end

