module Renalware
  class MedicationVersion < PaperTrail::Version
    self.table_name = :medication_versions
  end
end