require_dependency "renalware"

module Renalware
  module PD
    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::PD::Patient)
    end
  end
end
