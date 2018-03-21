# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Virology
    def self.table_name_prefix
      "virology_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Virology::Patient)
    end
  end
end
