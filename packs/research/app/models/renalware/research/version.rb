module Renalware
  module Research
    class Version < PaperTrail::Version
      self.table_name = :research_versions
    end
  end
end
