module Renalware
  module Transplants
    class DonorWorkupVersion < PaperTrail::Version
      self.table_name = :transplants_donor_workup_versions
    end
  end
end
