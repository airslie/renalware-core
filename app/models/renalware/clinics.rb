# frozen_string_literal: true

module Renalware
  module Clinics
    def self.table_name_prefix = "clinic_"

    def self.cast_patient(patient)
      ActiveType.cast(
        patient,
        ::Renalware::Clinics::Patient,
        force: Renalware.config.force_cast_active_types
      )
    end
  end
end
