require_dependency "renalware"

module Renalware
  module PD
    def self.table_name_prefix
      "pd_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::PD::Patient)
    end
  end
end
