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

    def self.cast_primary_care_physician(primary_care_physician)
      ActiveType.cast(primary_care_physician, ::Renalware::Letters::PrimaryCarePhysician)
    end
  end
end
