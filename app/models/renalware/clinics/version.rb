# frozen_string_literal: true

module Renalware
  module Clinics
    class Version < PaperTrail::Version
      self.table_name = :clinic_versions
    end
  end
end
