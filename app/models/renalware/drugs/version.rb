# frozen_string_literal: true

require_dependency "renalware/drugs"

module Renalware
  module Drugs
    class Version < PaperTrail::Version
      self.table_name = :drug_versions
    end
  end
end
