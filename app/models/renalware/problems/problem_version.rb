require_dependency "renalware/problems"

module Renalware
  module Problems
    class ProblemVersion < PaperTrail::Version
      self.table_name = :problem_versions
    end
  end
end
