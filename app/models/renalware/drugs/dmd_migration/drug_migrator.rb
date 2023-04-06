# frozen_string_literal: true

module Renalware
  module Drugs
    module DMDMigration
      class DrugMigrator
        def call
          drug_ids_by_name = Drugs::Drug.pluck(:name, :id).to_h
          dmd_matches = DMDMatch.where(approved_vtm_match: true).where.not(vtm_name: nil)

          dmd_matches.each do |dmd_match|
            Medications::Prescription
              .where(drug_id: dmd_match.drug_id)
              .update_all(
                drug_id: drug_ids_by_name[dmd_match.vtm_name],
                legacy_drug_id: dmd_match.drug_id
              )
          end
        end
      end
    end
  end
end
