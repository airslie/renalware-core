require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Version < PaperTrail::Version
      self.table_name = :transplant_versions
    end
  end
end
