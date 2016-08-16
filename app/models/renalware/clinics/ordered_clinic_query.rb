require_dependency "renalware/pathology"
require "sql/index_case_stmt"

module Renalware
  module Clinics
    class OrderedClinicQuery
      def initialize(clinic_ids)
        @clinic_ids = clinic_ids
      end

      def call
        Clinic
          .where(id: @clinic_ids)
          .order(ids_index)
      end

      private

      def ids_index
        ::SQL::IndexedCaseStmt.new(:id, @clinic_ids).generate
      end
    end
  end
end
