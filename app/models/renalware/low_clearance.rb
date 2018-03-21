# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module LowClearance
    MDM_FILTERS = %w(urea hgb_low hgb_high on_worryboard).freeze # tx_candidates

    def self.table_name_prefix
      "low_clearance_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::LowClearance::Patient)
    end
  end
end
