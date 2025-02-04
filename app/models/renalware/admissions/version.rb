module Renalware
  module Admissions
    class Version < PaperTrail::Version
      self.table_name = :admission_versions
    end
  end
end
