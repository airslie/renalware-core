# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Clinics
    class Version < PaperTrail::Version
      self.table_name = :clinic_versions
    end
  end
end
