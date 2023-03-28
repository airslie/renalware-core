# frozen_string_literal: true

module Renalware
  module Drugs
    module DMDMigration
      class TradeFamilyMigrator
        def call
          trade_family_ids_by_name = Drugs::TradeFamily.pluck(:name, :id).to_h
          dmd_matches = DMDMatch.where(approved_trade_family_match: true).where.not(trade_family_name: nil)

          dmd_matches.each do |dmd_match|
            Medications::Prescription.where(trade_family_id: nil)
              .where(drug_id: dmd_match.drug_id)
              .update_all(trade_family_id: trade_family_ids_by_name[dmd_match.trade_family_name])
          end
        end
      end
    end
  end
end
