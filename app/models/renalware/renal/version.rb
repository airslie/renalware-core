require_dependency "renalware/accesses"

module Renalware
  module Renal
    class Version < PaperTrail::Version
      self.table_name = :renal_versions
    end
  end
end
