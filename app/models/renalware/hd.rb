module Renalware
  module HD
    def self.table_name_prefix
      "hd_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::HD::Patient)
    end
  end
end
