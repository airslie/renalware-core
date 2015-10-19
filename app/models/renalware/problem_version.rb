module Renalware
  class ProblemVersion < PaperTrail::Version
    self.table_name = :problem_versions
    include DefaultVersionScope
  end
end