# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class Version < PaperTrail::Version
      self.table_name = :research_versions
    end
  end
end
