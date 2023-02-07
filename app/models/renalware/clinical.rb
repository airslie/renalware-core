# frozen_string_literal: true

module Renalware
  module Clinical
    def self.table_name_prefix = "clinical_"

    def self.cast_patient(patient)
      ActiveType.cast(
        patient,
        ::Renalware::Clinical::Patient,
        force: Renalware.config.force_cast_active_types
      )
    end
  end
end
