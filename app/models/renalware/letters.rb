require_dependency "renalware"
require_dependency "renalware/letters/author"

module Renalware
  module Letters
    def self.table_name_prefix
      "letter_"
    end

    def self.cast_author(user)
      ActiveType.cast(user, Author)
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Letters::Patient)
    end

    def self.cast_doctor(doctor)
      ActiveType.cast(doctor, ::Renalware::Letters::Doctor)
    end

    def self.cast_clinic_visit(clinic_visit)
      ActiveType.cast(clinic_visit, ::Renalware::Letters::ClinicVisit)
    end
  end
end
