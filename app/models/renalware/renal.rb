# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Renal
    def self.table_name_prefix
      "renal_"
    end

    def self.cast_patient(patient)
      return patient if patient.is_a?(::Renalware::Renal::Patient)

      ActiveType.cast(patient, ::Renalware::Renal::Patient)
    end
  end
end
