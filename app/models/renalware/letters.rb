module Renalware
  module Letters
    module_function

    def self.table_name_prefix
      "letter_"
    end

    def cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Letters::Patient)
    end
  end
end