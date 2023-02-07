# frozen_string_literal: true

module Renalware
  module Renal
    def self.table_name_prefix = "renal_"

    def self.cast_patient(patient)
      return patient if patient.is_a?(::Renalware::Renal::Patient)

      ActiveType.cast(
        patient,
        ::Renalware::Renal::Patient,
        force: Renalware.config.force_cast_active_types
      )
    end
  end
end
