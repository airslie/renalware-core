module Renalware
  module Transplants
    def self.table_name_prefix
      "transplant_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Transplants::Patient)
    end
  end
end
