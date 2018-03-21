# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class Version < PaperTrail::Version
      self.table_name = :clinical_versions
    end
  end
end
