# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class Version < PaperTrail::Version
      self.table_name = :virology_versions
    end
  end
end
