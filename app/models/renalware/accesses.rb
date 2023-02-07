# frozen_string_literal: true

module Renalware
  module Accesses
    def self.table_name_prefix = "access_"

    def self.cast_patient(patient)
      ActiveType.cast(
        patient,
        ::Renalware::Accesses::Patient,
        force: Renalware.config.force_cast_active_types
      )
    end
  end
end
