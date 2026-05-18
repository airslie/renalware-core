# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class Version < PaperTrail::Version
        self.table_name = "renalware_heroic.biobank_versions"
      end
    end
  end
end
