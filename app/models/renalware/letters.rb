require_dependency "renalware"

module Renalware
  module Letters
    def self.table_name_prefix
      "letter_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Letters::Patient)
    end

    def self.cast_doctor(doctor)
      ActiveType.cast(doctor, ::Renalware::Letters::Doctor)
    end
  end
end