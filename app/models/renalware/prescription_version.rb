module Renalware
  class PrescriptionVersion < PaperTrail::Version
    self.table_name = :prescription_versions
  end
end
