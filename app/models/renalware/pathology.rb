require_dependency "renalware"

module Renalware
  module Pathology
    def self.table_name_prefix
      "pathology_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Pathology::Patient)
    end
  end
end
