require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class DonorOperationVersion < PaperTrail::Version
      self.table_name = :transplants_donor_operation_versions
    end
  end
end
