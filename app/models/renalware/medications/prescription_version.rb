require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionVersion < PaperTrail::Version
      self.table_name = :prescription_versions
    end
  end
end
