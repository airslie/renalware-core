require_dependency "renalware/pathology"
require "sql/index_case_stmt"

module Renalware
  module Pathology
    class ObservationDescriptionsByCodeQuery
      def initialize(relation: ObservationDescription, codes:)
        @relation = relation
        @codes = codes
      end

      # Executes SQL that looks like this:
      #   SELECT "pathology_observation_descriptions".* FROM "pathology_observation_descriptions"
      #   WHERE "pathology_observation_descriptions"."code" IN ('HGB', 'MCV', 'MCH',...
      #   ORDER BY CASE code
      #     WHEN 'HGB' THEN 0
      #     WHEN 'MCV' THEN 1
      #     WHEN 'MCH' THEN 2
      #     ...
      #   END
      # and returns results that look like this:
      #   [
      #     #<Renalware::Pathology::ObservationDescription id: 767, code: "HGB", name: "HGB">,
      #     #<Renalware::Pathology::ObservationDescription id: 1058, code: "MCV", name: "MCV">,
      #     #<Renalware::Pathology::ObservationDescription id: 1055, code: "MCH", name: "MCH">,
      #     ...
      #   ]
      def call
        stmt = SQL::IndexedCaseStmt.new(:code, @codes) # Generate a CASE statement for ordering
        records = @relation.where(code: @codes).order(stmt.generate)
        verify_all_records_found(records)
        records
      end

      private

      def verify_all_records_found(records)
        found_codes = records.map(&:code)

        missing_records = found_codes - @codes
        if missing_records.present?
          raise ActiveRecord::RecordNotFound, "Missing records for #{missing_records}"
        end
      end
    end
  end
end
