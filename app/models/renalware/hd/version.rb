require_dependency "renalware/transplants"

module Renalware
  module Hd
    class Version < PaperTrail::Version
      self.table_name = :hd_versions
    end
  end
end
