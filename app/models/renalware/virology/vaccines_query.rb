# frozen_string_literal: true

module Renalware
  module Virology
    # If the vaccination type has any values in its atc_codes array, use those to
    # filter drugs with a type of 'vaccine'. If no atc_codes, return all vaccine drugs.
    class VaccinesQuery
      pattr_initialize [:vaccination_type!]

      def call
        vaccination_type.atc_codes.any? ? vaccines_filtered_by_atc_code : all_vaccines
      end

      private

      def all_vaccines = Renalware::Drugs::Drug.for(:vaccine)

      def vaccines_filtered_by_atc_code
        sql = <<~SQL.squish
          select distinct on (drugs.id) drugs.* from drugs
          inner join drug_types_drugs dtd on dtd.drug_id = drugs.id
          inner join drug_types dt on dt.id = dtd.drug_type_id
          inner join drug_dmd_virtual_medical_products ddvmp on ddvmp.virtual_therapeutic_moiety_code = drugs.code
          inner join virology_vaccination_types vvt on ddvmp.atc_code ~~ ANY(vvt.atc_codes)
          where dt.code = 'vaccine' and drugs.inactive = 'false' and vvt.id = ?
        SQL
        sanitized_sql = Vaccination.sanitize_sql([sql, vaccination_type.id])
        Drugs::Drug.find_by_sql(sanitized_sql)
      end
    end
  end
end
