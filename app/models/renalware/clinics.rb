module Renalware
  module Clinics
    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Clinics::Patient)
    end
  end
end
