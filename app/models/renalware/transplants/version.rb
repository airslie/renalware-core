require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Version < PaperTrail::Version
      self.table_name = :transplants_versions
    end
  end
end
