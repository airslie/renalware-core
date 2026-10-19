require "csv"

module Renalware
  module Drugs
    module DMDMigration
      class MatchExport
        HEADERS = %w(drug_id drug_name prescriptions_count vtm_name approved_vtm_match
                     trade_family_name approved_trade_family_match form_name).freeze

        def call(matches)
          CSV.generate do |csv|
            csv << HEADERS
            matches.pluck(*HEADERS).each do |row|
              row[4] = row[4] ? "TRUE" : "FALSE"
              row[6] = row[6] ? "TRUE" : "FALSE"
              csv << row
            end
          end
        end
      end
    end
  end
end
