require_dependency "renalware/problems"

module Renalware
  module Problems
    class Version < PaperTrail::Version
      self.table_name = :problems_versions
    end
  end
end
